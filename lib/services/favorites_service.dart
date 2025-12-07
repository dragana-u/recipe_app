import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal_detail_model.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_meals';

  Future<void> addFavorite(MealDetail meal) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    if (!favorites.any((m) => m.id == meal.id)) {
      favorites.add(meal);
      final jsonList = favorites.map((m) => m.toJson()).toList();
      await prefs.setString(_favoritesKey, json.encode(jsonList));
    }
  }

  Future<void> removeFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    favorites.removeWhere((m) => m.id == mealId);
    final jsonList = favorites.map((m) => m.toJson()).toList();
    await prefs.setString(_favoritesKey, json.encode(jsonList));
  }

  Future<List<MealDetail>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_favoritesKey);

    if (favoritesJson == null || favoritesJson.isEmpty) {
      return [];
    }

    final List<dynamic> jsonList = json.decode(favoritesJson);
    return jsonList.map((json) => MealDetail.fromJson(json)).toList();
  }

  Future<bool> isFavorite(String mealId) async {
    final favorites = await getFavorites();
    return favorites.any((m) => m.id == mealId);
  }

  Future<bool> toggleFavorite(MealDetail meal) async {
    final isFav = await isFavorite(meal.id);

    if (isFav) {
      await removeFavorite(meal.id);
      return false;
    } else {
      await addFavorite(meal);
      return true;
    }
  }
}
