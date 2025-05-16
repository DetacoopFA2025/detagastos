import 'package:detagastos/screens/transactions/create_transaction_screen.dart';
import 'package:detagastos/utils/number_formatter.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';
import '../widgets/summary_card.dart';
import '../widgets/transactions_section.dart';
import 'transactions/transactions_list_screen.dart';

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
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTransactions,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SummaryCard(
                    title: 'Balance',
                    amount: NumberFormatter.formatCompact(
                        _transactionService.getBalance()),
                    color: colorScheme.primary,
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                  SummaryCard(
                    title: 'Ingresos',
                    amount: NumberFormatter.formatCompact(
                        _transactionService.getTotalIncomes()),
                    color: colorScheme.primary,
                    icon: Icons.trending_up_rounded,
                  ),
                  SummaryCard(
                    title: 'Gastos',
                    amount: NumberFormatter.formatCompact(
                        _transactionService.getTotalExpenses()),
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
                _onViewAll(TransactionType.expense);
              },
              onAdd: () {
                _createTransaction(context, TransactionType.expense);
              },
              refreshTransactions: _loadTransactions,
            ),
            const SizedBox(height: 16),
            // Sección de Ingresos
            TransactionsSection(
              title: 'Ingresos Recientes',
              transactions: _transactionService.getIncomes(),
              color: colorScheme.primary,
              icon: Icons.trending_up_rounded,
              onViewAll: () {
                _onViewAll(TransactionType.income);
              },
              onAdd: () {
                _createTransaction(context, TransactionType.income);
              },
              refreshTransactions: _loadTransactions,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onViewAll(TransactionType type) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionsListScreen(
          type: type,
          title: type == TransactionType.expense ? 'Gastos' : 'Ingresos',
        ),
      ),
    );

    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {});
  }

  Future<void> _createTransaction(
      BuildContext context, TransactionType type) async {
    final result = await Navigator.push<Transaction>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTransactionScreen(
          initialType: type,
        ),
      ),
    );

    _loadTransactions();
    if (result != null && mounted) {
      _loadTransactions();
    }
  }
}
