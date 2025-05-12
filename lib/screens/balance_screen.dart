import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';
import '../utils/number_formatter.dart';
import 'package:detagastos/widgets/statistics/account_selector.dart';
import 'package:detagastos/widgets/statistics/range_selector.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  String? _selectedAccountId;
  final _transactionService = TransactionService();

  List<Transaction> _getFilteredTransactions() {
    return _transactionService.transactions
        .where((t) =>
            t.date.isAfter(_startDate) &&
            t.date.isBefore(_endDate.add(const Duration(days: 1))))
        .where((t) =>
            _selectedAccountId == null || t.accountId == _selectedAccountId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final transactions = _getFilteredTransactions();
    final incomeTransactions =
        transactions.where((t) => t.type == TransactionType.income).toList();
    final expenseTransactions =
        transactions.where((t) => t.type == TransactionType.expense).toList();

    final totalIncome =
        incomeTransactions.fold<double>(0, (sum, t) => sum + t.amount);
    final totalExpense =
        expenseTransactions.fold<double>(0, (sum, t) => sum + t.amount);
    final balance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Balance',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Filtros
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
            const SizedBox(height: 20),
            // Contenedores de información
            Row(
              children: [
                Expanded(
                  child: _InfoContainer(
                    title: 'Movimientos',
                    value: transactions.length.toString(),
                    subtitle: 'Total',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _InfoContainer(
                    title: 'Ingresos',
                    value: NumberFormatter.formatCompact(totalIncome),
                    subtitle:
                        '${incomeTransactions.length} movimientos\n${NumberFormatter.formatWithSeparator(totalIncome)}',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _InfoContainer(
                    title: 'Egresos',
                    value: NumberFormatter.formatCompact(totalExpense),
                    subtitle:
                        '${expenseTransactions.length} movimientos\n${NumberFormatter.formatWithSeparator(totalExpense)}',
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _InfoContainer(
                    title: 'Saldo',
                    value: NumberFormatter.formatCompact(balance),
                    subtitle:
                        '${balance >= 0 ? 'Positivo' : 'Negativo'}\n${NumberFormatter.formatWithSeparator(balance)}',
                    color: balance >= 0 ? Colors.blue : Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoContainer extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _InfoContainer({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
