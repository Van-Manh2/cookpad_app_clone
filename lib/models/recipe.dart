import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String name;
  final String imageUrl;
  final String author;
  final List<String> keywords;
  final DateTime createdAt;

  Recipe({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.keywords,
    required this.author,
    required this.createdAt,
  });

  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recipe(
      id: doc.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      keywords: List<String>.from(data['keywords'] ?? []),
      author: data['author'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
