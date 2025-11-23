import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../models/meal_detail_model.dart';

class MealCard extends StatelessWidget {
  final dynamic meal;
  final VoidCallback onTap;

  const MealCard({super.key, required this.meal, required this.onTap});

  String get mealName =>
      meal is Meal ? (meal as Meal).name : (meal as MealDetail).name;

  String get mealThumbnail =>
      meal is Meal ? (meal as Meal).thumbnail : (meal as MealDetail).thumbnail;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Image.network(
                  mealThumbnail,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    mealName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
