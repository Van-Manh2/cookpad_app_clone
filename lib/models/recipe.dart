import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final String author;
  final String category;
  final int searchCount;
  final DateTime createdAt;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.author,
    required this.category,
    required this.searchCount,
    required this.createdAt,
  });

  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recipe(
      id: doc.id,
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      author: data['author'] ?? '',
      category: data['category'] ?? '',
      searchCount: data['searchCount'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
