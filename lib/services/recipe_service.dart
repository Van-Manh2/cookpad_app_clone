import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpad_app_clone/models/recipe.dart';

class RecipeService {
  final CollectionReference _recipeCollection = FirebaseFirestore.instance
      .collection('recipes');

  Future<List<Recipe>> getAllRecipes() async {
    final snapshot = await _recipeCollection.get();
    return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
  }

  Future<List<Recipe>> getRecipesByKeyword(String keyword) async {
    final snapshot =
        await _recipeCollection.where('keywords', arrayContains: keyword).get();
    return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
  }

  Future<List<Recipe>> getRecipesByCategoryId(String categoryId) async {
    final snapshot =
        await _recipeCollection
            .where('categoryId', isEqualTo: categoryId)
            .get();
    return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
  }

  Future<void> addRecipe(Recipe recipe) async {
    await _recipeCollection.add({
      'title': recipe.name,
      'imageUrl': recipe.imageUrl,
      'author': recipe.author,
      'keywords': recipe.keywords,
    });
  }

  Future<void> updateRecipe(String id, Recipe recipe) async {
    await _recipeCollection.doc(id).update({
      'title': recipe.name,
      'imageUrl': recipe.imageUrl,
      'author': recipe.author,
      'keywords': recipe.keywords,
    });
  }

  Future<void> deleteRecipe(String id) async {
    await _recipeCollection.doc(id).delete();
  }

  Future<List<Recipe>> getRecentlyAddedRecipes() async {
    try {
      final snapshot =
          await _recipeCollection
              .orderBy('createdAt', descending: true)
              .limit(8)
              .get();

      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
