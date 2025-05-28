import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookpad_app_clone/enums/recipe_status.dart';

class Recipe {
  final String id;
  final String name;
  final String description;
  final String authorId;
  String? authorName;
  final String authorEmail;
  final String imageUrl;
  final String videoUrl;
  final RecipeStatus status;
  final bool isPublic;
  final int diet;
  final int popularity;
  final List<String> ingredients;
  final List<String> steps;
  final String time;
  final DateTime createdAt;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.authorId,
    required this.authorName,
    required this.authorEmail,
    required this.imageUrl,
    required this.videoUrl,
    required this.status,
    required this.isPublic,
    required this.diet,
    this.popularity = 0,
    required this.ingredients,
    required this.steps,
    required this.time,
    required this.createdAt,
  });

  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Recipe(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorId'] ?? '',
      authorEmail: data['authorEmail'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      status: RecipeStatusExt.fromStr(data['status'] ?? 'pending'),
      isPublic: data['isPublic'] ?? false,
      diet: data['diet'] ?? 0,
      popularity: data['popularity'] ?? 0,
      ingredients: List<String>.from(data['ingredients'] ?? []),
      steps: List<String>.from(data['steps'] ?? []),
      time: data['time'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'authorId': authorId,
      'authorName': authorName,
      'authorEmail': authorEmail,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'status': status.index,
      'isPublic': isPublic,
      'diet': diet,
      'popularity': popularity,
      'ingredients': ingredients,
      'steps': steps,
      'time': time,
      'createdAt': createdAt,
    };
  }
}
