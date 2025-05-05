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
    final totalIncomes = _transactionService.getTotalIncomes();
    final totalExpenses = _transactionService.getTotalExpenses();
    final balance = _transactionService.getBalance();
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final sectionWidth = screenWidth * 0.75;

    return Scaffold(
      backgroundColor: theme.colorScheme.primary.withOpacity(0.05),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'DetaGastos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Summary Cards Slider
                SizedBox(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SummaryCard(
                        title: 'Ingresos',
                        amount: _formatAmount(totalIncomes),
                        color: theme.colorScheme.primary,
                        icon: Icons.trending_up_rounded,
                      ),
                      SummaryCard(
                        title: 'Gastos',
                        amount: _formatAmount(totalExpenses),
                        color: theme.colorScheme.error,
                        icon: Icons.trending_down_rounded,
                      ),
                      SummaryCard(
                        title: 'Balance',
                        amount: _formatAmount(balance),
                        color: theme.colorScheme.secondary,
                        icon: Icons.account_balance_wallet_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Transactions Sections
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'Transacciones Recientes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Transactions Slider
                    SizedBox(
                      height: 400,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          // Gastos Section
                          Container(
                            width: sectionWidth,
                            margin: const EdgeInsets.only(right: 12),
                            child: TransactionsSection(
                              title: 'Gastos',
                              transactions: _transactionService.getExpenses(),
                              color: theme.colorScheme.error,
                              icon: Icons.trending_down_rounded,
                              addIcon: Icons.add_circle_outline,
                              onViewAll: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TransactionsListScreen(
                                      type: TransactionType.expense,
                                      title: 'Gastos',
                                    ),
                                  ),
                                );
                                setState(() {});
                              },
                              onAdd: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateItemScreen(),
                                  ),
                                );
                                setState(() {});
                              },
                            ),
                          ),
                          // Ingresos Section
                          Container(
                            width: sectionWidth,
                            child: TransactionsSection(
                              title: 'Ingresos',
                              transactions: _transactionService.getIncomes(),
                              color: theme.colorScheme.primary,
                              icon: Icons.trending_up_rounded,
                              addIcon: Icons.add_circle_outline,
                              onViewAll: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TransactionsListScreen(
                                      type: TransactionType.income,
                                      title: 'Ingresos',
                                    ),
                                  ),
                                );
                                setState(() {});
                              },
                              onAdd: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateItemScreen(),
                                  ),
                                );
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
}
