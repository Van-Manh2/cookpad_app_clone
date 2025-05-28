import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpad_app_clone/models/recipe.dart';
import 'package:cookpad_app_clone/utils/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

class RecipeService {
  final Logger _logger = AppLogger.getLogger('RecipeService');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _recipeCollection => _firestore.collection('recipes');

  Future<List<Recipe>> getAllRecipes() async {
    final snapshot = await _recipeCollection.get();
    return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
  }

  Future<List<Recipe>> getNewestRecipes(int limit) async {
    try {
      final snapshot =
          await _recipeCollection
              .orderBy('createdAt', descending: true)
              .limit(limit)
              .get();

      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    } catch (e, stacktrace) {
      _logger.severe('Lỗi khi lấy công thức mới nhất: $e', e, stacktrace);
      rethrow;
    }
  }

  Future<void> incrementPopularity(String id, {int value = 1}) async {
    try {
      final docRef = _recipeCollection.doc(id);
      await docRef.update({'popularity': FieldValue.increment(value)});
    } catch (e) {
      _logger.severe('Lỗi khi tăng độ phổ biến: $e');
    }
  }

  Future<List<Recipe>> getPopularRecipes(int limit) async {
    try {
      final snapshot =
          await _recipeCollection
              .orderBy('popularity', descending: true)
              .limit(limit)
              .get();

      final recipes =
          snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();

      _logger.info('Lấy ${recipes.length} công thức phổ biến nhất.');
      return recipes;
    } catch (e, stacktrace) {
      _logger.severe('Lỗi khi lấy công thức phổ biến: $e', e, stacktrace);
      rethrow;
    }
  }

  Future<List<Recipe>> searchRecipes(String query, int limit) async {
    try {
      final snapshot =
          await _recipeCollection.where('status', isEqualTo: 'approved').get();

      final matched =
          snapshot.docs
              .map((doc) => Recipe.fromFirestore(doc))
              .where(
                (recipe) =>
                    recipe.name.toLowerCase().contains(query.toLowerCase()) ||
                    recipe.ingredients.any(
                      (ing) => ing.toLowerCase().contains(query.toLowerCase()),
                    ),
              )
              .take(limit)
              .toList();

      return matched;
    } catch (e, stacktrace) {
      _logger.severe('Lỗi tìm kiếm công thức: $e', e, stacktrace);
      rethrow;
    }
  }

  Future<List<String>> getSearchHistory() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data();
      return (data?['searchHistory'] as List<dynamic>?)
              ?.cast<String>()
              .toList() ??
          [];
    } catch (e) {
      _logger.warning('Lỗi lấy lịch sử tìm kiếm: $e');
      return [];
    }
  }

  Future<void> saveSearchKeyword(String keyword) async {
    final user = _auth.currentUser;
    if (user == null || keyword.trim().isEmpty) return;

    try {
      final ref = _firestore.collection('users').doc(user.uid);
      final doc = await ref.get();

      List<String> history =
          (doc.data()?['searchHistory'] as List?)?.cast<String>() ?? [];

      history.remove(keyword);
      history.insert(0, keyword);

      if (history.length > 10) {
        history = history.sublist(0, 10);
      }

      await ref.set({'searchHistory': history}, SetOptions(merge: true));
    } catch (e) {
      _logger.warning('Lỗi lưu lịch sử tìm kiếm: $e');
    }
  }

  Future<List<Recipe>> getSuggestionsByQuery(String query, int limit) async {
    try {
      final snapshot = await _recipeCollection.get();

      final matched =
          snapshot.docs
              .map((doc) => Recipe.fromFirestore(doc))
              .where(
                (recipe) =>
                    recipe.name.toLowerCase().contains(query.toLowerCase()) ||
                    recipe.ingredients.any(
                      (ing) => ing.toLowerCase().contains(query.toLowerCase()),
                    ),
              )
              .take(limit)
              .toList();

      return matched;
    } catch (e, stacktrace) {
      _logger.severe('Lỗi gợi ý công thức: $e', e, stacktrace);
      rethrow;
    }
  }

  Future<void> clearSearchHistory() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'searchHistory': [],
      });
    } catch (e) {
      _logger.warning('Lỗi xóa lịch sử tìm kiếm: $e');
    }
  }
}
