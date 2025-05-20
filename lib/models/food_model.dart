import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  final String? id;
  final String name;
  final String picture;
  final int diet;
  final String time;
  final String description;
  final String ingredients;
  final String step;
  final Timestamp? timestamp;
  final String? authorName;
  final String? authorAvatar;

  Food({
    this.id,
    required this.name,
    required this.picture,
    required this.diet,
    required this.time,
    required this.description,
    required this.ingredients,
    required this.step,
    this.timestamp,
    this.authorName,
    this.authorAvatar,
  });

  // Create a Food object from a Firestore document
  factory Food.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Food(
      id: doc.id,
      name: data['name'] ?? '',
      picture: data['picture'] ?? '',
      diet: data['diet'] ?? 0,
      time: data['time'] ?? '',
      description: data['description'] ?? '',
      ingredients: data['ingredients'] ?? '',
      step: data['step'] ?? '',
      timestamp: data['timestamp'],
      authorName: data['authorName'],
      authorAvatar: data['authorAvatar'],
    );
  }

  // Convert Food object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'picture': picture,
      'diet': diet,
      'time': time,
      'description': description,
      'ingredients': ingredients,
      'step': step,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
      if (authorName != null) 'authorName': authorName,
      if (authorAvatar != null) 'authorAvatar': authorAvatar,
    };
  }

  // Create a copy of Food with some fields updated
  Food copyWith({
    String? id,
    String? name,
    String? picture,
    int? diet,
    String? time,
    String? description,
    String? ingredients,
    String? step,
    Timestamp? timestamp,
    String? authorName,
    String? authorAvatar,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      picture: picture ?? this.picture,
      diet: diet ?? this.diet,
      time: time ?? this.time,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      step: step ?? this.step,
      timestamp: timestamp ?? this.timestamp,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
    );
  }
} 