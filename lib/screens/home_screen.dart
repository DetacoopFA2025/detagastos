import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';
import '../widgets/summary_card.dart';
import '../widgets/transactions_section.dart';
import 'transactions_list_screen.dart';
import 'create_item_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TransactionService _transactionService = TransactionService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/detacoop.png', width: 32, height: 32),
            const SizedBox(width: 8),
            const Text(
              'DetaGastos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTransactions,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Resumen de transacciones
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SummaryCard(
                    title: 'Balance',
                    amount: _formatAmount(_transactionService.getBalance()),
                    color: colorScheme.primary,
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                  SummaryCard(
                    title: 'Ingresos',
                    amount:
                        _formatAmount(_transactionService.getTotalIncomes()),
                    color: colorScheme.primary,
                    icon: Icons.trending_up_rounded,
                  ),
                  SummaryCard(
                    title: 'Gastos',
                    amount:
                        _formatAmount(_transactionService.getTotalExpenses()),
                    color: colorScheme.primary,
                    icon: Icons.trending_down_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TransactionsSection(
              title: 'Gastos Recientes',
              transactions: _transactionService.getExpenses(),
              color: colorScheme.primary,
              icon: Icons.trending_down_rounded,
              onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransactionsListScreen(
                      type: TransactionType.expense,
                      title: 'Gastos',
                    ),
                  ),
                );
              },
              onAdd: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateItemScreen(
                      initialType: TransactionType.expense,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Sección de Ingresos
            TransactionsSection(
              title: 'Ingresos Recientes',
              transactions: _transactionService.getIncomes(),
              color: colorScheme.primary,
              icon: Icons.trending_up_rounded,
              onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransactionsListScreen(
                      type: TransactionType.income,
                      title: 'Ingresos',
                    ),
                  ),
                );
              },
              onAdd: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateItemScreen(
                      initialType: TransactionType.income,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)} millones';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(1)} mil';
    } else {
      return '\$${amount.toStringAsFixed(0)}';
    }
  }

  Future<void> _loadTransactions() async {
    setState(() {});
  }
}
