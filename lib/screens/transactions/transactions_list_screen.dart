import 'package:flutter/material.dart';
import '../../models/transaction.dart';
import '../../services/transaction_service.dart';
import '../../widgets/transaction_item.dart';
import '../transactions/create_transaction_screen.dart';

class TransactionsListScreen extends StatefulWidget {
  final TransactionType type;
  final String title;

  const TransactionsListScreen({
    super.key,
    required this.type,
    required this.title,
  });

  @override
  State<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
  final _transactionService = TransactionService();
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final transactions = widget.type == TransactionType.expense
          ? _transactionService.getExpenses()
          : _transactionService.getIncomes();
      if (mounted) {
        setState(() {
          _transactions = transactions;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar las transacciones: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _transactions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.type == TransactionType.expense
                            ? Icons.trending_down_rounded
                            : Icons.trending_up_rounded,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay ${widget.type == TransactionType.expense ? 'gastos' : 'ingresos'} registrados',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = _transactions[index];
                    return TransactionItem(
                      transaction: transaction,
                      onEdit: (updatedTransaction) {
                        _loadTransactions();
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createTransaction(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _createTransaction(BuildContext context) async {
    final result = await Navigator.push<Transaction>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTransactionScreen(
          initialType: widget.type,
        ),
      ),
    );

    _loadTransactions();
    if (result != null && mounted) {
      _loadTransactions();
    }
  }
}
