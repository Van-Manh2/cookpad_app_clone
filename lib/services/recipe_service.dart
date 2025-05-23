import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';

class RecipeService {
  final CollectionReference _recipesCollection =
      FirebaseFirestore.instance.collection('recipes');

  // Create a new recipe
  Future<void> createRecipe(RecipeModel recipe) async {
    await _recipesCollection.add(recipe.toMap());
  }

  // Update an existing recipe
  Future<void> updateRecipe(String id, RecipeModel recipe) async {
    await _recipesCollection.doc(id).update(recipe.toMap());
  }

  // Delete a recipe
  Future<void> deleteRecipe(String id) async {
    await _recipesCollection.doc(id).delete();
  }

  // Get all recipes
  Stream<List<RecipeModel>> getRecipes() {
    return _recipesCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              RecipeModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get a single recipe by ID
  Future<RecipeModel?> getRecipeById(String id) async {
    final doc = await _recipesCollection.doc(id).get();
    if (doc.exists) {
      return RecipeModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Get recipes by author
  Stream<List<RecipeModel>> getRecipesByAuthor(String authorId) {
    return _recipesCollection
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

  // Get public recipes
  Stream<List<RecipeModel>> getPublicRecipes() {
    return _recipesCollection
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

  // Get pending recipe requests
  Stream<List<RecipeModel>> getPendingRecipes() {
    return _recipesCollection
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

  // Update recipe status (for admin)
  Future<void> updateRecipeStatus(String id, String status) async {
    await _recipesCollection.doc(id).update({
      'status': status,
      'isPublic': status == 'approved',
    });
  }

  // Add a comment to a recipe
  Future<void> addComment(String recipeId, Comment comment) async {
    try {
      final recipe = await getRecipeById(recipeId);
      if (recipe != null) {
        final updatedComments = [...recipe.comments, comment];
        await _recipesCollection.doc(recipeId).update({
          'comments': updatedComments.map((c) => c.toMap()).toList(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  // Search recipes
  Stream<List<RecipeModel>> searchRecipes(String query) {
    return _recipesCollection
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
