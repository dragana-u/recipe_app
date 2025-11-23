import 'package:flutter/material.dart';

import 'meal_card.dart';


class MealGrid extends StatelessWidget {
  final List<dynamic> meals;
  final Function(dynamic meal) onMealTap;

  const MealGrid({super.key, required this.meals, required this.onMealTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 200 / 244,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: meals.length,
      itemBuilder: (context, index) {
        return MealCard(
          meal: meals[index],
          onTap: () => onMealTap(meals[index]),
        );
      },
    );
  }
}
