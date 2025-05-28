import 'package:flutter/material.dart';

class PopularSearch extends StatelessWidget {
  final String title;
  final String? imageUrl;

  const PopularSearch({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              imageUrl != null ? '$imageUrl' : 'logo_cookpad1.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('logo_cookpad1.png');
              },
            ),
          ),
          Positioned(
            left: 8,
            bottom: 8,
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
