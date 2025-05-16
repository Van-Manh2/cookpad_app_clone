import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpad_app_clone/models/recipe.dart';

class RecipeService {
  final CollectionReference _recipeCollection = FirebaseFirestore.instance
      .collection('recipes');

  Future<List<String>> getPopularCategories({int top = 8}) async {
    final snapshot = await _recipeCollection.get();

    final Map<String, int> categorySearchCount = {};

    for (dynamic doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final category = data['category'] ?? 'Khác';
      final searchCount = (data['searchCount'] ?? 0) as num;

      categorySearchCount[category] =
          (categorySearchCount[category] ?? 0) + searchCount.toInt();
    }

    final sortedCategories =
        categorySearchCount.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return sortedCategories.take(top).map((e) => e.key).toList();
  }

  Future<List<Recipe>> getRecipesOfPopularCategories({int top = 8}) async {
    final topCategories = await getPopularCategories(top: top);
    if (topCategories.isEmpty) return [];

    final snapshot =
        await _recipeCollection.where('category', whereIn: topCategories).get();

    return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
  }

  Future<List<Recipe>> getRecentlyAddedRecipes() async {
    try {
      final snapshot =
          await _recipeCollection
              .orderBy('createdAt', descending: true)
              .limit(10)
              .get();

      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
