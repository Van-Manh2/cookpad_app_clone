import 'package:flutter/material.dart';
import '../models/food_model.dart';

class FoodDetail extends StatelessWidget {
  final Food food;

  const FoodDetail({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(food.name),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (food.picture.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  food.picture,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey,
                    child:
                        const Icon(Icons.image, color: Colors.white, size: 50),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.timer, color: Colors.white70),
                const SizedBox(width: 8),
                Text(
                  food.time,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.restaurant, color: Colors.white70),
                const SizedBox(width: 8),
                Text(
                  'Chế độ ăn: ${food.diet}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Mô tả',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              food.description,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            const Text(
              'Nguyên liệu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              food.ingredients,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            const Text(
              'Các bước thực hiện',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              food.step,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}