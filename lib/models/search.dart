import 'package:cloud_firestore/cloud_firestore.dart';

class Search {
  final String id;
  final String keyword;
  final String userId;
  final DateTime timestamp;

  Search({
    required this.id,
    required this.keyword,
    required this.userId,
    required this.timestamp,
  });

  factory Search.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Search(
      id: doc.id,
      keyword: data['keyword'] ?? '',
      userId: data['userId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'keyword': keyword,
    'timestamp': timestamp.toIso8601String(),
  };
}
