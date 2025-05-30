import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpad_app_clone/models/search.dart';
import 'package:cookpad_app_clone/services/auth_service.dart';
import 'package:cookpad_app_clone/services/search_service.dart';
import '../models/recipe.dart';

class RecipeService {
  final CollectionReference _recipeCollection = FirebaseFirestore.instance
      .collection('recipes');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SearchService _searchService = SearchService();

  Future<List<Recipe>> getAllApprovedRecipes() async {
    try {
      final snapshot =
          await _recipeCollection.where('status', isEqualTo: 'approved').get();
      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting recipes: $e');
      return [];
    }
  }

  Future<List<Recipe>> getRecipesByAuthor(String authorId) async {
    try {
      final snapshot =
          await _recipeCollection
              .where('authorId', isEqualTo: authorId)
              .where('status', isEqualTo: 'approved')
              .get();
      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting recipes by author: $e');
      return [];
    }
  }

  Future<List<Recipe>> searchRecipes(String query, {int limit = -1}) async {
    try {
      final snapshot =
          await _recipeCollection.where('status', isEqualTo: 'approved').get();

      final lowerQuery = query.toLowerCase();

      final results =
          snapshot.docs
              .map((doc) => Recipe.fromFirestore(doc))
              .where(
                (recipe) =>
                    recipe.name.toLowerCase().contains(lowerQuery) ||
                    recipe.ingredients.any(
                      (ingredient) =>
                          ingredient.toLowerCase().contains(lowerQuery),
                    ) ||
                    recipe.authorName?.toLowerCase().contains(lowerQuery) ==
                        true,
              )
              .toList();

      return limit > 0 ? results.take(limit).toList() : results;
    } catch (e) {
      print('Error searching recipes: $e');
      return [];
    }
  }

  Future<void> incrementRecipePopularity(String recipeId) async {
    try {
      await _recipeCollection.doc(recipeId).update({
        'popularity': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing popularity: $e');
    }
  }

  Future<List<Recipe>> getPopularRecipes(int limit) async {
    try {
      final snapshot =
          await _recipeCollection
              .orderBy('popularity', descending: true)
              .limit(limit)
              .get();

      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting popular recipes: $e');
      return [];
    }
  }

  Future<List<Recipe>> getNewestRecipes(int limit) async {
    try {
      final snapshot =
          await _recipeCollection
              .orderBy('createdAt', descending: true)
              .limit(limit)
              .get();

      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting the newest recipes: $e');
      return [];
    }
  }

  Future<List<Recipe>> getNewestRecipesByKeyword(
    String keyword,
    int limit,
  ) async {
    try {
      final snapshot =
          await _recipeCollection
              .where('name', isGreaterThanOrEqualTo: keyword)
              .where('name', isLessThanOrEqualTo: '$keyword\uf8ff')
              .orderBy('name')
              .orderBy('createdAt', descending: true)
              .limit(limit)
              .get();

      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting newest recipes by keyword: $e');
      return [];
    }
  }

  Future<List<Recipe>> getPopularRecipesByKeyword(
    String keyword,
    int limit,
  ) async {
    try {
      final snapshot =
          await _recipeCollection
              .where('name', isGreaterThanOrEqualTo: keyword)
              .where('name', isLessThanOrEqualTo: '$keyword\uf8ff')
              .orderBy('name')
              .orderBy('popularity', descending: true)
              .limit(limit)
              .get();

      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting popular recipes by keyword: $e');
      return [];
    }
  }

  Future<List<String>> getSearchHistory(String userId, int limit) async {
    try {
      final snapshot = await _firestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        final data = snapshot.data();
        final List<dynamic> historyDynamic = data?['searchHistory'] ?? [];
        final List<String> history = historyDynamic.cast<String>();
        return history.length > limit ? history.sublist(0, limit) : history;
      }
      return [];
    } catch (e) {
      print('Error getting search history: $e');
      return [];
    }
  }

  Future<void> saveSearchKeyword(String keyword) async {
    final user = await AuthService().getCurrentUser();
    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);

    try {
      final snapshot = await userDoc.get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        List<dynamic> history = data['searchHistory'] ?? [];

        history.remove(keyword);
        history.insert(0, keyword);

        if (history.length > 5) {
          history = history.sublist(0, 5);
        }

        await userDoc.update({'searchHistory': history});
      } else {
        await userDoc.set({
          'searchHistory': [keyword],
        });
      }

      final doc = _firestore.collection('searches').doc();

      final newSearch = Search(
        id: doc.id,
        userId: user.uid,
        keyword: keyword,
        timestamp: DateTime.now(),
      );
      await _searchService.saveSearch(newSearch);
    } catch (e) {
      print('Error saving search keyword: $e');
    }
  }

  Future<void> clearSearchHistory() async {
    final user = await AuthService().getCurrentUser();
    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);
    try {
      await userDoc.update({'searchHistory': []});
    } catch (e) {
      print('Error clearing search history: $e');
    }
  }
}
