import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';
import '../widgets/transaction_item.dart';
import 'create_item_screen.dart';

class TransactionsListScreen extends StatelessWidget {
  final TransactionType type;
  final String title;

  const TransactionsListScreen({
    super.key,
    required this.type,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final transactionService = TransactionService();
    final transactions = type == TransactionType.expense
        ? transactionService.getExpenses()
        : transactionService.getIncomes();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: transactions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    type == TransactionType.expense
                        ? Icons.trending_down_rounded
                        : Icons.trending_up_rounded,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay ${type == TransactionType.expense ? 'gastos' : 'ingresos'} registrados',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return TransactionItem(
                  title: transaction.title,
                  amount: transaction.formattedAmount,
                  date: _formatDate(transaction.date),
                  category: transaction.category,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false,
            arguments: {
              'selectedIndex': 3,
              'createType':
                  type == TransactionType.expense ? 'expense' : 'income',
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
