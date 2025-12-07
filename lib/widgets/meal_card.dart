import 'package:flutter/material.dart';
import 'package:recipe_app/services/favorites_service.dart';
import '../models/meal_model.dart';
import '../models/meal_detail_model.dart';

class MealCard extends StatefulWidget {
  final dynamic meal;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteChanged;

  const MealCard({
    super.key,
    required this.meal,
    required this.onTap,
    this.onFavoriteChanged,
  });

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  final FavoritesService _favoritesService = FavoritesService();
  bool _isFavorite = false;
  bool _isLoading = false;

  String get mealId => widget.meal is Meal
      ? (widget.meal as Meal).id
      : (widget.meal as MealDetail).id;

  String get mealName => widget.meal is Meal
      ? (widget.meal as Meal).name
      : (widget.meal as MealDetail).name;

  String get mealThumbnail => widget.meal is Meal
      ? (widget.meal as Meal).thumbnail
      : (widget.meal as MealDetail).thumbnail;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFav = await _favoritesService.isFavorite(mealId);
    if (mounted) {
      setState(() => _isFavorite = isFav);
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final newStatus = await _favoritesService.toggleFavorite(widget.meal);

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
          duration: const Duration(seconds: 1),
          backgroundColor: newStatus ? Colors.green : Colors.red,
        ),
      );

      widget.onFavoriteChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Column(
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
                  ),
                ],
              ),
              if (widget.meal is MealDetail)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _toggleFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.orange,
                              ),
                            )
                          : Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _isFavorite
                                  ? Colors.red
                                  : Colors.grey[600],
                              size: 24,
                            ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
