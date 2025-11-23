import 'package:flutter/material.dart';

class MealDetailImage extends StatelessWidget {
  final String imageUrl;

  const MealDetailImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        imageUrl,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 250,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 250,
            color: Colors.grey[300],
            child: const Icon(
              Icons.restaurant_menu,
              size: 60,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}