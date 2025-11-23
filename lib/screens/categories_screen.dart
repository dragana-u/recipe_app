import 'package:flutter/material.dart';

import '../models/meal_category_model.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final RecipeApiService _apiService = RecipeApiService();
  late final List<MealCategory> _allCategories;
  List<MealCategory> _filteredCategories = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);

    final categories = await _apiService.loadCategories();

    setState(() {
      _allCategories = categories;
      _filteredCategories = categories;
      _isLoading = false;
    });
  }

  void _filterCategories(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredCategories = _allCategories;
      } else {
        _filteredCategories = _allCategories
            .where(
              (category) =>
                  category.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  // Future<void> _showRandomMeal() async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => const Center(child: CircularProgressIndicator()),
  //   );
  //
  //   final randomMeal = await _apiService.getRandomMeal();
  //
  //   if (!mounted) return;
  //   Navigator.pop(context);
  //
  //   if (randomMeal != null) {
  //     Navigator.pushNamed(context, '/details', arguments: randomMeal);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Грешка при вчитување на рецептот')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange[700],
        title: const Text(
          '🍽️ Категории на храна',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.shuffle, color: Colors.white),
          //   tooltip: 'Рандом рецепт',
          //   onPressed: _showRandomMeal,
          // ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : Column(
              children: [
                _buildSearchBar(),
                _buildCategoryCount(),
                Expanded(child: _buildCategoriesGrid()),
              ],
            ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[700],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterCategories,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Пребарај категорија...',
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white),
                  onPressed: () {
                    _searchController.clear();
                    _filterCategories('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCount() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[100]!, Colors.orange[50]!],
        ),
      )
    );
  }

  Widget _buildCategoriesGrid() {
    if (_filteredCategories.isEmpty && _searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Нема пронајдено категории',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
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

    return RefreshIndicator(
      onRefresh: _loadCategories,
      color: Colors.orange,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _filteredCategories.length,
        itemBuilder: (context, index) {
          return CategoryCard(
            category: _filteredCategories[index],
            onTap: () {
              Navigator.pushNamed(
                context,
                '/meals',
                arguments: _filteredCategories[index],
              );
            },
          );
        },
      ),
    );
  }
}
