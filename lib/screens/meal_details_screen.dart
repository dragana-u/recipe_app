import 'package:flutter/material.dart';
import '../models/meal_detail_model.dart';
import '../widgets/meal_detail_image.dart';
import '../widgets/meal_detail_title.dart';
import '../widgets/meal_detail_info.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final meal = ModalRoute.of(context)!.settings.arguments as MealDetail;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          meal.name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            MealDetailImage(imageUrl: meal.thumbnail),
            const SizedBox(height: 20),
            MealDetailTitle(
              name: meal.name,
              category: meal.category
            ),
            const SizedBox(height: 20),
            MealDetailInfo(
              instructions: meal.instructions,
              ingredients: meal.ingredients,
              youtubeUrl: meal.youtubeUrl,
            ),
          ],
        ),
      ),
    );
  }
}