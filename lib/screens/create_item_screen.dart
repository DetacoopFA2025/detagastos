import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'create_transaction_screen.dart';
import 'create_category_screen.dart';

class CreateItemScreen extends StatefulWidget {
  final TransactionType? initialType;

  const CreateItemScreen({
    super.key,
    this.initialType,
  });

  @override
  State<CreateItemScreen> createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {
  late TransactionType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType ?? TransactionType.expense;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedType == TransactionType.expense
            ? 'Nuevo Gasto'
            : 'Nuevo Ingreso'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Transaction Type Selector
            SegmentedButton<TransactionType>(
              style: SegmentedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              segments: const [
                ButtonSegment<TransactionType>(
                  value: TransactionType.expense,
                  label: Text('Gasto'),
                  icon: Icon(Icons.trending_down_rounded),
                ),
                ButtonSegment<TransactionType>(
                  value: TransactionType.income,
                  label: Text('Ingreso'),
                  icon: Icon(Icons.trending_up_rounded),
                ),
              ],
              selected: {_selectedType},
              onSelectionChanged: (Set<TransactionType> selected) {
                setState(() {
                  _selectedType = selected.first;
                });
              },
            ),
            const SizedBox(height: 24),

            // Create Transaction Option
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateTransactionScreen(
                        initialType: _selectedType,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        _selectedType == TransactionType.expense
                            ? Icons.trending_down_rounded
                            : Icons.trending_up_rounded,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Crear ${_selectedType == TransactionType.expense ? 'Gasto' : 'Ingreso'}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Registra un nuevo ${_selectedType == TransactionType.expense ? 'gasto' : 'ingreso'} en tu cuenta',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Create Category Option
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateCategoryScreen(
                        isExpense: _selectedType == TransactionType.expense,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Crear Categoría de ${_selectedType == TransactionType.expense ? 'Gasto' : 'Ingreso'}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Añade una nueva categoría para organizar tus ${_selectedType == TransactionType.expense ? 'gastos' : 'ingresos'}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
