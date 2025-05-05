import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'transaction_item.dart';

class TransactionsSection extends StatelessWidget {
  final String title;
  final List<Transaction> transactions;
  final Color color;
  final IconData icon;
  final IconData addIcon;
  final VoidCallback onViewAll;
  final VoidCallback onAdd;

  const TransactionsSection({
    super.key,
    required this.title,
    required this.transactions,
    required this.color,
    required this.icon,
    required this.addIcon,
    required this.onViewAll,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4,
            color: color,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: onViewAll,
                      child: Text(
                        'Ver todo',
                        style: TextStyle(
                          color: color,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onAdd,
                      icon: Icon(
                        addIcon,
                        color: color,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (transactions.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'No hay ${title.toLowerCase()} registrados',
                  style: TextStyle(
                    color: color.withOpacity(0.7),
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: transactions.take(3).map((t) {
                  return TransactionItem(
                    title: t.title,
                    amount: t.formattedAmount,
                    date: _formatDate(t.date),
                    category: t.category,
                  );
                }).toList(),
              ),
            ),
        ],
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
