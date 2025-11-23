import 'package:flutter/material.dart';

import '../models/meal_category_model.dart';
import '../models/meal_detail_model.dart';
import '../services/api_service.dart';
import '../widgets/meal_grid.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final RecipeApiService _apiService = RecipeApiService();

  List<dynamic> _allMeals = [];
  List<dynamic> _filteredMeals = [];

  bool _isLoading = true;
  bool _isSearching = false;

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  MealCategory? _category;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_category == null) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is MealCategory) {
        _category = args;
        _loadMeals(args.name);
      }
    }
  }

  Future<void> _loadMeals(String categoryName) async {
    setState(() => _isLoading = true);

    final meals = await _apiService.loadMealsByCategory(categoryName);

    setState(() {
      _allMeals = meals;
      _filteredMeals = meals;
      _isLoading = false;
    });
  }

  Future<void> _searchMealsByName(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      setState(() => _filteredMeals = _allMeals);
      return;
    }

    setState(() => _isSearching = true);

    final result = await _apiService.searchMealsByName(query);

    final filteredByCategory = result.where((meal) {
      return meal.category.toLowerCase() == _category?.name.toLowerCase();
    }).toList();

    setState(() {
      _filteredMeals = filteredByCategory;
      _isSearching = false;
    });
  }

  Future<void> _openMeal(dynamic meal) async {
    if (meal is MealDetail) {
      Navigator.pushNamed(context, '/details', arguments: meal);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final mealDetail = await _apiService.getMealDetails(meal.id);

    if (!mounted) return;
    Navigator.pop(context);

    if (mealDetail != null) {
      Navigator.pushNamed(context, '/details', arguments: mealDetail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Јадења од: ${_category?.name ?? ''}"),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildMealsGrid()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _searchController,
        onChanged: (query) {
          if (query.length >= 2) {
            _searchMealsByName(query);
          } else {
            setState(() {
              _searchQuery = '';
              _filteredMeals = _allMeals;
            });
          }
        },
        decoration: InputDecoration(
          hintText: 'Пребарај јадење...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
                _filteredMeals = _allMeals;
              });
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildMealsGrid() {
    if (_filteredMeals.isEmpty && _searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Нема јадење со тоа име',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Обидете се со друг збор',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return MealGrid(
      meals: _filteredMeals,
      onMealTap: _openMeal,
    );
  }
}
