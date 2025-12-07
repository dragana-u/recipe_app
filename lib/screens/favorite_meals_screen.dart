import 'package:flutter/material.dart';
import 'package:recipe_app/services/favorites_service.dart';
import '../models/meal_detail_model.dart';
import '../widgets/meal_grid.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  List<MealDetail> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);

    final favorites = await _favoritesService.getFavorites();

    setState(() {
      _favorites = favorites;
      _isLoading = false;
    });
  }

  Future<void> _openMeal(dynamic meal) async {
    await Navigator.pushNamed(
        context,
        '/details',
        arguments: meal
    );
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange[700],
        title: const Text(
          'Омилени рецепти',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      )
          : _favorites.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: _loadFavorites,
        child: MealGrid(
          meals: _favorites,
          onMealTap: _openMeal,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'Немате омилени рецепти',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Додадете рецепти со притискање на ❤️',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}