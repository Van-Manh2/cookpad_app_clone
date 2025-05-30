import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/search.dart';

class SearchService {
  final CollectionReference _searchCollection = FirebaseFirestore.instance
      .collection('searches');

  Future<List<Search>> getSearchHistory() async {
    try {
      final snapshot =
          await _searchCollection
              .orderBy('timestamp', descending: true)
              .limit(20)
              .get();

      return snapshot.docs.map((doc) => Search.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error in getSearchHistory: $e');
      return [];
    }
  }

  Future<List<Search>> getAllSearches() async {
    try {
      final snapshot = await _searchCollection.get();

      return snapshot.docs.map((doc) => Search.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error in getAllSearches: $e');
      return [];
    }
  }

  Future<void> deleteSearch(String id) async {
    try {
      await _searchCollection.doc(id).delete();
    } catch (e) {
      print('Error in deleteSearch: $e');
    }
  }

  Future<void> clearAllSearches() async {
    try {
      final snapshot = await _searchCollection.get();
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error in clearAllSearches: $e');
    }
  }

  Future<void> saveSearch(Search search) async {
    try {
      if (search.id.isNotEmpty) {
        await _searchCollection.doc(search.id).set(search.toMap());
      } else {
        await _searchCollection.add(search.toMap());
      }
    } catch (e) {
      print('Error in saveSearch: $e');
    }
  }
}
