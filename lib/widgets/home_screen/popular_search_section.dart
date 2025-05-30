import 'package:cookpad_app_clone/models/recipe.dart';
import 'package:cookpad_app_clone/widgets/home_screen/popular_search.dart';
import 'package:flutter/material.dart';

class PopularRecipesSection extends StatelessWidget {
  final Future<List<Recipe>> future;

  const PopularRecipesSection({required this.future, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Lỗi: ${snapshot.error}',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Chưa có công thức phổ biến',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final recipes = snapshot.data!;
        return SizedBox(
          height: 300,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2,
            ),
            itemCount: recipes.length.clamp(0, 8),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return GestureDetector(
                onTap: () {
                  
                },
                child: PopularSearch(
                  title: recipe.name,
                  imageUrl: recipe.imageUrl,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
