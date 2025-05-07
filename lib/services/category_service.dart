import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';

class CategoryService {
  static final CategoryService _instance = CategoryService._internal();
  factory CategoryService() => _instance;
  CategoryService._internal();

  static const String _expenseCategoriesKey = 'expense_categories';
  static const String _incomeCategoriesKey = 'income_categories';

  final Map<CategoryType, List<Category>> _categories = {
    CategoryType.expense: [
      const Category(name: 'Alimentación', emoji: '🍔', isExpense: true),
      const Category(name: 'Transporte', emoji: '🚗', isExpense: true),
      const Category(name: 'Vivienda', emoji: '🏠', isExpense: true),
      const Category(name: 'Salud', emoji: '💊', isExpense: true),
      const Category(name: 'Entretenimiento', emoji: '🎮', isExpense: true),
      const Category(name: 'Educación', emoji: '📚', isExpense: true),
      const Category(name: 'Ropa', emoji: '👕', isExpense: true),
      const Category(name: 'Servicios', emoji: '💡', isExpense: true),
      const Category(name: 'Otros', emoji: '📦', isExpense: true),
    ],
    CategoryType.income: [
      const Category(name: 'Salario', emoji: '💰', isExpense: false),
      const Category(name: 'Pensión', emoji: '👴', isExpense: false),
      const Category(name: 'Inversiones', emoji: '📈', isExpense: false),
      const Category(name: 'Ventas', emoji: '🛍️', isExpense: false),
      const Category(name: 'Freelance', emoji: '💻', isExpense: false),
      const Category(name: 'Regalo', emoji: '🎁', isExpense: false),
      const Category(name: 'Otros', emoji: '📦', isExpense: false),
    ],
  };

  Future<void> init() async {
    await _loadCategories();
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();

    for (final type in CategoryType.values) {
      final key = type == CategoryType.expense
          ? _expenseCategoriesKey
          : _incomeCategoriesKey;
      final json = prefs.getString(key);

      if (json != null) {
        final List<dynamic> decoded = jsonDecode(json);
        _categories[type] = decoded
            .map((item) => Category(
                  name: item['name'],
                  emoji: item['emoji'],
                  isExpense: type == CategoryType.expense,
                ))
            .toList();
      }
    }
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();

    for (final type in CategoryType.values) {
      final key = type == CategoryType.expense
          ? _expenseCategoriesKey
          : _incomeCategoriesKey;
      final json = jsonEncode(_categories[type]!
          .map((category) => {
                'name': category.name,
                'emoji': category.emoji,
              })
          .toList());
      await prefs.setString(key, json);
    }
  }

  List<Category> getExpenseCategories() => _categories[CategoryType.expense]!;
  List<Category> getIncomeCategories() => _categories[CategoryType.income]!;

  Future<void> addCategory(Category category) async {
    _categories[category.type]!.add(category);
    await _saveCategories();
  }

  Future<void> removeCategory(Category category) async {
    _categories[category.type]!.removeWhere((c) => c.name == category.name);
    await _saveCategories();
  }

  Category? getCategoryByName(String name, bool isExpense) {
    final type = isExpense ? CategoryType.expense : CategoryType.income;
    return _categories[type]!.firstWhere(
      (category) => category.name == name,
      orElse: () => _categories[type]!.last,
    );
  }

  String getEmojiByCategory(String name, bool isExpense) {
    return getCategoryByName(name, isExpense)!.emoji;
  }
}
