import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

class TransactionService {
  static final TransactionService _instance = TransactionService._internal();
  factory TransactionService() => _instance;
  TransactionService._internal();

  static const String _storageKey = 'transactions';
  List<Transaction> _transactions = [];
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadTransactions();
  }

  List<Transaction> get transactions => List.unmodifiable(_transactions);

  List<Transaction> getExpenses() {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<Transaction> getIncomes() {
    return _transactions.where((t) => t.type == TransactionType.income).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  double getTotalExpenses() {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double getTotalIncomes() {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double getBalance() {
    return getTotalIncomes() - getTotalExpenses();
  }

  Future<void> addTransaction(Transaction transaction) async {
    _transactions.add(transaction);
    await _saveTransactions();
  }

  Future<void> removeTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    await _saveTransactions();
  }

  void _loadTransactions() {
    final String? transactionsJson = _prefs.getString(_storageKey);
    if (transactionsJson != null) {
      final List<dynamic> decoded = jsonDecode(transactionsJson);
      _transactions = decoded
          .map((item) => Transaction.fromMap(item as Map<String, dynamic>))
          .toList();
    }
  }

  Future<void> _saveTransactions() async {
    final String encoded =
        jsonEncode(_transactions.map((t) => t.toMap()).toList());
    await _prefs.setString(_storageKey, encoded);
  }
}
