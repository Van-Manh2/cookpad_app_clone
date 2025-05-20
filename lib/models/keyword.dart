import 'package:cloud_firestore/cloud_firestore.dart';

class Keyword {
  final String id;
  final String title;
  final String? image;
  final int searchCount;

  Keyword({
    required this.id,
    required this.title,
    this.image,
    required this.searchCount,
  });

  factory Keyword.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Keyword(
      id: doc.id,
      title: data['title'] ?? '',
      image: data['image'],
      searchCount: data['searchCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      if (image != null) 'image': image,
      'searchCount': searchCount,
    };
  }
}
