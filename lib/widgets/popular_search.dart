import 'dart:math';
import 'package:flutter/material.dart';

class PopularSearch extends StatelessWidget {
  final String recipeCategory;

  const PopularSearch({super.key, required this.recipeCategory});

  @override
  Widget build(BuildContext context) {
    final List<String> defaultCategoryImages = [
      'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
      'https://images.unsplash.com/photo-1512058564366-c9e7a4f3b9cd',
      'https://images.unsplash.com/photo-1543353071-087092ec393f',
      'https://images.unsplash.com/photo-1506354666786-959d6d497f1a',
      'https://images.unsplash.com/photo-1606755962778-3b6db583a3e8',
      'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe',
      'https://images.unsplash.com/photo-1605478902780-9c945d54c48f',
      'https://images.unsplash.com/photo-1590080876534-c1d5d7e289ec',
    ];

    final random = Random();
    final imageUrl =
        defaultCategoryImages[random.nextInt(defaultCategoryImages.length)];
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Positioned.fill(child: Image.network(imageUrl, fit: BoxFit.cover)),
          Positioned(
            left: 8,
            bottom: 8,
            child: Text(
              recipeCategory,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
