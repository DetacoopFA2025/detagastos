import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/account_service.dart';
import 'transactions/create_transaction_screen.dart';
import 'categories/categories_screen.dart';
import 'accounts/accounts_screen.dart';

class CreateItemScreen extends StatelessWidget {
  final TransactionType? initialType;

  const CreateItemScreen({
    super.key,
    this.initialType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botón para crear transacción
            FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateTransactionScreen(
                      initialType: initialType,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Nueva Transacción'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.account_balance_outlined),
              label: const Text('Gestionar Cuentas'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoriesScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.category_outlined),
              label: const Text('Gestionar Categorías'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
