import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/meal_category_model.dart';
import '../models/meal_detail_model.dart';
import '../models/meal_model.dart';

class RecipeApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<MealCategory>> loadCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final categoriesJson = data['categories'] as List;
        return categoriesJson
            .map((json) => MealCategory.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error loading categories: $e');
      return [];
    }
  }

  Future<List<Meal>> loadMealsByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/filter.php?c=$category'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] == null) return [];

        final mealsJson = data['meals'] as List;
        return mealsJson.map((json) => Meal.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error loading meals by category: $e');
      return [];
    }
  }

  Future<List<MealDetail>> searchMealsByName(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search.php?s=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] == null) return [];

        final mealsJson = data['meals'] as List;
        return mealsJson.map((json) => MealDetail.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error searching meals: $e');
      return [];
    }
  }

  Future<MealDetail?> getMealDetails(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] == null || data['meals'].isEmpty) return null;

        return MealDetail.fromJson(data['meals'][0]);
      }
      return null;
    } catch (e) {
      print('Error loading meal details: $e');
      return null;
    }
  }

  Future<MealDetail?> getRandomMeal() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/random.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] == null || data['meals'].isEmpty) return null;

        return MealDetail.fromJson(data['meals'][0]);
      }
      return null;
    } catch (e) {
      print('Error loading random meal: $e');
      return null;
    }
  }
}
