import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'transaction_item.dart';

class TransactionsSection extends StatelessWidget {
  final String title;
  final List<Transaction> transactions;
  final Color color;
  final IconData icon;
  final VoidCallback onViewAll;
  final VoidCallback onAdd;

  const TransactionsSection({
    super.key,
    required this.title,
    required this.transactions,
    required this.color,
    required this.icon,
    required this.onViewAll,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: onViewAll,
                  child: const Text('Ver todo'),
                ),
                IconButton(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (transactions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No hay transacciones registradas',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: transactions.length > 3 ? 240 : transactions.length * 80.0,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length > 3 ? 3 : transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return TransactionItem(
                  transaction: transaction,
                );
              },
            ),
          ),
      ],
    );
  }
}
