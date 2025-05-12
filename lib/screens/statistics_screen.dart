import 'package:detagastos/widgets/statistics/account_selector.dart';
import 'package:detagastos/widgets/statistics/pie_section.dart';
import 'package:detagastos/widgets/statistics/range_selector.dart';
import 'package:detagastos/widgets/transaction_type_selector.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  String? _selectedAccountId;
  final _transactionService = TransactionService();
  late TransactionType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = TransactionType.expense;
  }

  @override
  Widget build(BuildContext context) {
    final transactions = _transactionService.transactions
        .where((t) => t.type == _selectedType)
        .where((t) =>
            t.date.isAfter(_startDate) &&
            t.date.isBefore(_endDate.add(const Duration(days: 1))))
        .where((t) =>
            _selectedAccountId == null || t.accountId == _selectedAccountId)
        .toList();

    // Calcular totales por categoría
    final categoryTotals = <String, double>{};
    for (final transaction in transactions) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }

    // Ordenar categorías por monto
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Estadísticas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Filtros
            TransactionTypeSelector(
              selectedType: _selectedType,
              onTypeSelected: (type) {
                setState(() {
                  _selectedType = type;
                });
              },
            ),
            const SizedBox(height: 10),
            RangeSelector(
              startDate: _startDate,
              endDate: _endDate,
              onDateRangeSelected: (range) {
                setState(() {
                  _startDate = range.start;
                  _endDate = range.end;
                });
              },
            ),
            const SizedBox(height: 10),
            AccountSelector(
              selectedAccountId: _selectedAccountId,
              onAccountSelected: (value) {
                setState(() {
                  _selectedAccountId = value;
                });
              },
            ),
            const SizedBox(height: 10), // Gráfico y Leyenda
            if (transactions.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No hay transacciones en el período seleccionado',
                  style: TextStyle(fontSize: 16),
                ),
              )
            else
              PieSection(
                transactions: transactions,
                sortedCategories: sortedCategories,
              ),
          ],
        ),
      ),
    );
  }
}
