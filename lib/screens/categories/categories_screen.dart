import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../services/category_service.dart';
import 'create_category_screen.dart';
import '../../widgets/delete_confirmation_dialog.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  final _categoryService = CategoryService();
  late final TabController _tabController;
  List<Category> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Gastos'),
            Tab(text: 'Ingresos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CategoryList(
            categories: _categoryService.getExpenseCategories(),
            onDelete: _deleteCategory,
            onEdit: _editCategory,
          ),
          _CategoryList(
            categories: _categoryService.getIncomeCategories(),
            onDelete: _deleteCategory,
            onEdit: _editCategory,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createCategory(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _createCategory(BuildContext context) async {
    final result = await Navigator.push<Category>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateCategoryScreen(
          isExpense: _tabController.index == 0,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {});
    }
  }

  Future<void> _editCategory(Category category) async {
    final result = await Navigator.push<Category>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateCategoryScreen(
          isExpense: category.isExpense,
          initialCategory: category,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {});
    }
  }

  Future<void> _deleteCategory(Category category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        resourceType: 'categoría',
        resourceName: category.name,
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await _categoryService.removeCategory(category);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Categoría eliminada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          _loadCategories();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar la categoría: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final expenseCategories = _categoryService.getExpenseCategories();
      final incomeCategories = _categoryService.getIncomeCategories();
      if (mounted) {
        setState(() {
          _categories = [...expenseCategories, ...incomeCategories];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar las categorías: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class _CategoryList extends StatelessWidget {
  final List<Category> categories;
  final Function(Category) onDelete;
  final Function(Category) onEdit;

  const _CategoryList({
    required this.categories,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          child: ListTile(
            leading: Text(
              category.emoji,
              style: const TextStyle(fontSize: 24),
            ),
            title: Text(category.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => onEdit(category),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onDelete(category),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
