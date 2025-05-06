import '../models/category.dart';

class CategoryService {
  static final CategoryService _instance = CategoryService._internal();
  factory CategoryService() => _instance;
  CategoryService._internal();

  final List<Category> _expenseCategories = [
    const Category(name: 'Alimentación', emoji: '🍔', isExpense: true),
    const Category(name: 'Transporte', emoji: '🚗', isExpense: true),
    const Category(name: 'Vivienda', emoji: '🏠', isExpense: true),
    const Category(name: 'Salud', emoji: '💊', isExpense: true),
    const Category(name: 'Entretenimiento', emoji: '🎮', isExpense: true),
    const Category(name: 'Educación', emoji: '📚', isExpense: true),
    const Category(name: 'Ropa', emoji: '👕', isExpense: true),
    const Category(name: 'Servicios', emoji: '💡', isExpense: true),
    const Category(name: 'Otros', emoji: '📦', isExpense: true),
  ];

  final List<Category> _incomeCategories = [
    const Category(name: 'Salario', emoji: '💰', isExpense: false),
    const Category(name: 'Pensión', emoji: '👴', isExpense: false),
    const Category(name: 'Inversiones', emoji: '📈', isExpense: false),
    const Category(name: 'Ventas', emoji: '🛍️', isExpense: false),
    const Category(name: 'Freelance', emoji: '💻', isExpense: false),
    const Category(name: 'Regalo', emoji: '🎁', isExpense: false),
    const Category(name: 'Otros', emoji: '📦', isExpense: false),
  ];

  List<Category> getExpenseCategories() => _expenseCategories;
  List<Category> getIncomeCategories() => _incomeCategories;

  Category? getCategoryByName(String name, bool isExpense) {
    final categories = isExpense ? _expenseCategories : _incomeCategories;
    return categories.firstWhere(
      (category) => category.name == name,
      orElse: () => categories.last,
    );
  }

  String getEmojiByCategory(String name, bool isExpense) {
    final categories = isExpense ? _expenseCategories : _incomeCategories;
    return categories
        .firstWhere(
          (category) => category.name == name,
          orElse: () => categories.last,
        )
        .emoji;
  }
}
