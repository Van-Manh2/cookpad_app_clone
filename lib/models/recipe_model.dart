import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  final String? id;
  final String name;
  final String picture;
  final int diet;
  final String time;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final Timestamp timestamp;
  final String? authorId;
  final String? authorEmail;
  final bool isPublic;
  final String status; // 'pending', 'approved', 'rejected'
  final List<Comment> comments;

  RecipeModel({
    this.id,
    required this.name,
    required this.picture,
    required this.diet,
    required this.time,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.timestamp,
    this.authorId,
    this.authorEmail,
    this.isPublic = false,
    this.status = 'pending',
    this.comments = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'picture': picture,
      'diet': diet,
      'time': time,
      'description': description,
      'ingredients': ingredients,
      'steps': steps,
      'timestamp': timestamp,
      'authorId': authorId,
      'authorEmail': authorEmail,
      'isPublic': isPublic,
      'status': status,
      'comments': comments.map((c) => c.toMap()).toList(),
    };
  }

  factory RecipeModel.fromMap(String id, Map<String, dynamic> map) {
    return RecipeModel(
      id: id,
      name: map['name'] ?? '',
      picture: map['picture'] ?? '',
      diet: map['diet'] ?? 0,
      time: map['time'] ?? '00:00',
      description: map['description'] ?? '',
      ingredients: List<String>.from(map['ingredients'] ?? []),
      steps: List<String>.from(map['steps'] ?? []),
      timestamp: map['timestamp'] ?? Timestamp.now(),
      authorId: map['authorId'],
      authorEmail: map['authorEmail'],
      isPublic: map['isPublic'] ?? false,
      status: map['status'] ?? 'pending',
      comments: (map['comments'] as List<dynamic>?)
              ?.map((c) => Comment.fromMap(c as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Comment {
  final String userId;
  final String userEmail;
  final String content;
  final Timestamp timestamp;

  Comment({
    required this.userId,
    required this.userEmail,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'content': content,
      'timestamp': timestamp,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? '',
      content: map['content'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }
}