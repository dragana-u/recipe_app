import 'package:flutter/material.dart';
import 'package:recipe_app/services/favorites_service.dart';
import '../models/meal_detail_model.dart';
import '../widgets/meal_detail_image.dart';
import '../widgets/meal_detail_title.dart';
import '../widgets/meal_detail_info.dart';

class MealDetailsScreen extends StatefulWidget {
  const MealDetailsScreen({super.key});

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final meal = ModalRoute.of(context)!.settings.arguments as MealDetail;
    _checkFavoriteStatus(meal.id);
  }

  Future<void> _checkFavoriteStatus(String mealId) async {
    final isFav = await _favoritesService.isFavorite(mealId);
    if (mounted) {
      setState(() => _isFavorite = isFav);
    }
  }

  Future<void> _toggleFavorite(MealDetail meal) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final newStatus = await _favoritesService.toggleFavorite(meal);

    if (mounted) {
      setState(() {
        _isFavorite = newStatus;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus ? '❤️ Додадено во омилени' : '💔 Отстрането од омилени',
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: newStatus ? Colors.green : Colors.red,
        ),
      );
    }
  }

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _isLoading
                ? const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            )
                : IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => _toggleFavorite(meal),
            ),
          ),
        ],
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