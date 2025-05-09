import 'package:detagastos/models/transaction.dart';
import 'package:detagastos/services/account_service.dart';
import 'package:detagastos/services/category_service.dart';
import 'package:flutter/material.dart';
import '../screens/transactions/create_transaction_screen.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final Function(Transaction)? onEdit;
  final Function()? onDelete;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final categoryService = CategoryService();
    final accountService = AccountService();

    final isExpense = transaction.type == TransactionType.expense;
    final color = isExpense ? Colors.red.shade700 : Colors.green.shade700;
    final icon =
        categoryService.getEmojiByCategory(transaction.category, isExpense);

    return InkWell(
      onTap: () => _editTransaction(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon and Category
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(
                      fontSize: 24,
                      height: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Title and Category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      accountService.getAccountNameById(transaction.accountId),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Amount and Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transaction.formattedAmount,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.formatDate(),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editTransaction(BuildContext context) async {
    final result = await Navigator.push<Transaction>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTransactionScreen(
          initialType: transaction.type,
          initialTransaction: transaction,
        ),
      ),
    );

    if (result != null && context.mounted) {
      // Notificar al padre que la transacción fue actualizada
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transacción actualizada'),
          backgroundColor: Colors.green,
        ),
      );
      onEdit?.call(result);
    } else {
      onDelete?.call();
    }
  }
}
