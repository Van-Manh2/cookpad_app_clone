import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpad_app_clone/models/recipe_model.dart'; // Gồm cả RecipeModel và Comment

class RecipeService {
  final CollectionReference _recipeCollection =
      FirebaseFirestore.instance.collection('recipes');

  // Lấy danh sách các category phổ biến
  Future<List<String>> getPopularCategories({int top = 8}) async {
    final snapshot = await _recipeCollection.get();

    final Map<String, int> categorySearchCount = {};

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final category = data['category'] ?? 'Khác';
      final searchCount = (data['searchCount'] ?? 0) as num;

      categorySearchCount[category] =
          (categorySearchCount[category] ?? 0) + searchCount.toInt();
    }

    final sortedCategories = categorySearchCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedCategories.take(top).map((e) => e.key).toList();
  }

  // Lấy công thức thuộc các category phổ biến
  Future<List<RecipeModel>> getRecipesOfPopularCategories({int top = 8}) async {
    final topCategories = await getPopularCategories(top: top);
    if (topCategories.isEmpty) return [];

    final snapshot = await _recipeCollection
        .where('category', whereIn: topCategories)
        .get();

    return snapshot.docs
        .map((doc) =>
            RecipeModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Lấy công thức mới nhất
  Future<List<RecipeModel>> getRecentlyAddedRecipes() async {
    try {
      final snapshot = await _recipeCollection
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) =>
              RecipeModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Tạo công thức
  Future<void> createRecipe(RecipeModel recipe) async {
    await _recipeCollection.add(recipe.toMap());
  }

  // Cập nhật công thức
  Future<void> updateRecipe(String id, RecipeModel recipe) async {
    await _recipeCollection.doc(id).update(recipe.toMap());
  }

  // Xóa công thức
  Future<void> deleteRecipe(String id) async {
    await _recipeCollection.doc(id).delete();
  }

  // Lấy tất cả công thức
  Stream<List<RecipeModel>> getRecipes() {
    return _recipeCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              RecipeModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Lấy công thức theo ID
  Future<RecipeModel?> getRecipeById(String id) async {
    final doc = await _recipeCollection.doc(id).get();
    if (doc.exists) {
      return RecipeModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Lấy công thức theo tác giả
  Stream<List<RecipeModel>> getRecipesByAuthor(String authorId) {
    return _recipeCollection
        .where('authorId', isEqualTo: authorId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              RecipeModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Lấy công thức công khai
  Stream<List<RecipeModel>> getPublicRecipes() {
    return _recipeCollection
        .where('isPublic', isEqualTo: true)
        .where('status', isEqualTo: 'approved')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              RecipeModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Lấy công thức đang chờ duyệt
  Stream<List<RecipeModel>> getPendingRecipes() {
    return _recipeCollection
        .where('status', isEqualTo: 'pending')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              RecipeModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Cập nhật trạng thái công thức (duyệt/bị từ chối)
  Future<void> updateRecipeStatus(String id, String status) async {
    await _recipeCollection.doc(id).update({
      'status': status,
      'isPublic': status == 'approved',
    });
  }

  // Thêm bình luận
  Future<void> addComment(String recipeId, Comment comment) async {
    try {
      final recipe = await getRecipeById(recipeId);
      if (recipe != null) {
        final updatedComments = [...recipe.comments, comment];
        await _recipeCollection.doc(recipeId).update({
          'comments': updatedComments.map((c) => c.toMap()).toList(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  // Tìm kiếm công thức
  Stream<List<RecipeModel>> searchRecipes(String query) {
    return _recipeCollection
        .where('isPublic', isEqualTo: true)
        .where('status', isEqualTo: 'approved')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      final recipes = snapshot.docs
          .map((doc) =>
              RecipeModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();

      return recipes.where((recipe) {
        final name = recipe.name.toLowerCase();
        final description = recipe.description.toLowerCase();
        final searchQuery = query.toLowerCase();

        return name.contains(searchQuery) ||
            description.contains(searchQuery) ||
            recipe.ingredients.any(
                (ingredient) => ingredient.toLowerCase().contains(searchQuery));
      }).toList();
    });
  }
}
