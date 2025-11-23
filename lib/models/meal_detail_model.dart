import 'ingredient_model.dart';

class MealDetail {
  String id;
  String name;
  String category;
  String area;
  String instructions;
  String thumbnail;
  String? youtubeUrl;
  List<Ingredient> ingredients;

  MealDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    this.youtubeUrl,
    required this.ingredients,
  });

  MealDetail.fromJson(Map<String, dynamic> data)
    : id = data['idMeal'] ?? '',
      name = data['strMeal'] ?? '',
      category = data['strCategory'] ?? '',
      area = data['strArea'] ?? '',
      instructions = data['strInstructions'] ?? '',
      thumbnail = data['strMealThumb'] ?? '',
      youtubeUrl = data['strYoutube'],
      ingredients = _parseIngredients(data);

  static List<Ingredient> _parseIngredients(Map<String, dynamic> data) {
    List<Ingredient> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = data['strIngredient$i'];
      final measure = data['strMeasure$i'];

      if (ingredient != null &&
          ingredient.toString().trim().isNotEmpty &&
          ingredient.toString().trim() != '') {

        final measureStr = measure?.toString().trim() ?? '';
        if (measureStr.isNotEmpty && measureStr != ' ') {
          ingredients.add(
            Ingredient(name: ingredient.toString().trim(), measure: measureStr),
          );
        } else {
          ingredients.add(
            Ingredient(name: ingredient.toString().trim(), measure: ''),
          );
        }
      }
    }
    return ingredients;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'idMeal': id,
      'strMeal': name,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strMealThumb': thumbnail,
      'strYoutube': youtubeUrl,
    };

    for (int i = 0; i < ingredients.length && i < 20; i++) {
      json['strIngredient${i + 1}'] = ingredients[i].name;
      json['strMeasure${i + 1}'] = ingredients[i].measure;
    }

    return json;
  }
}
