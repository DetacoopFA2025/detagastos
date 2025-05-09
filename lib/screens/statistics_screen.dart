import 'package:detagastos/widgets/statistics/account_selector.dart';
import 'package:detagastos/widgets/statistics/range_selector.dart';
import 'package:detagastos/widgets/transaction_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
  int? _touchedIndex;
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
              Column(
                children: [
                  // Gráfico
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 1.5,
                            child: PieChart(
                              PieChartData(
                                sections:
                                    _createPieChartSections(sortedCategories),
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
                                startDegreeOffset: -90,
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        _touchedIndex = null;
                                        return;
                                      }
                                      _touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Total: \$${transactions.fold<double>(0, (sum, t) => sum + t.amount).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Leyenda
                  Card(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sortedCategories.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final category = sortedCategories[index];
                        final percentage = (category.value /
                                transactions.fold(
                                    0, (sum, t) => sum + t.amount)) *
                            100;
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 12,
                            backgroundColor: _getCategoryColor(index),
                          ),
                          title: Text(
                            category.key,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${category.value.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _createPieChartSections(
      List<MapEntry<String, double>> categories) {
    final total =
        categories.fold<double>(0, (sum, category) => sum + category.value);

    return List.generate(categories.length, (index) {
      final category = categories[index];
      final percentage = (category.value / total) * 100;
      final isTouched = index == _touchedIndex;

      return PieChartSectionData(
        color: _getCategoryColor(index),
        value: category.value,
        title:
            isTouched ? '\$${category.value.toStringAsFixed(0)}' : category.key,
        radius: isTouched ? 75 : 70,
        titleStyle: TextStyle(
          fontSize: isTouched ? 14 : 12,
          fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withAlpha(77),
              offset: const Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
        titlePositionPercentageOffset: 0.5,
        borderSide: BorderSide(
          color: Colors.white.withAlpha(51),
          width: 1,
        ),
      );
    });
  }

  Color _getCategoryColor(int index) {
    const baseColor = Color.fromRGBO(4, 60, 92, 1);
    final colors = [
      baseColor,
      const Color.fromRGBO(4, 60, 92, 0.9),
      const Color.fromRGBO(4, 80, 120, 1),
      const Color.fromRGBO(4, 60, 92, 0.7),
      const Color.fromRGBO(4, 100, 150, 1),
      const Color.fromRGBO(4, 60, 92, 0.5),
      const Color.fromRGBO(4, 120, 180, 1),
      const Color.fromRGBO(4, 60, 92, 0.3),
      const Color.fromRGBO(4, 140, 210, 1),
      const Color.fromRGBO(4, 60, 92, 0.1),
    ];
    return colors[index % colors.length];
  }
}
