import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/account.dart';

class AccountService {
  static final AccountService _instance = AccountService._internal();
  factory AccountService() => _instance;
  AccountService._internal();

  static const String _storageKey = 'accounts';
  List<Account> _accounts = [];
  late SharedPreferences _prefs;
  final _uuid = const Uuid();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadAccounts();
  }

  List<Account> get accounts => List.unmodifiable(_accounts);

  Future<void> addAccount(Account account) async {
    _accounts.add(account);
    await _saveAccounts();
  }

  Future<void> removeAccount(String id) async {
    _accounts.removeWhere((account) => account.id == id);
    await _saveAccounts();
  }

  Future<void> updateAccount(Account account) async {
    final index = _accounts.indexWhere((a) => a.id == account.id);
    if (index != -1) {
      _accounts[index] = account;
      await _saveAccounts();
    }
  }

  List<Account> _loadAccounts() {
    final accountsJson = _prefs.getStringList(_storageKey);
    if (accountsJson != null) {
      _accounts = accountsJson
          .map((json) => Account.fromJson(jsonDecode(json)))
          .toList();
    }
    return _accounts;
  }

  Future<void> _saveAccounts() async {
    await _prefs.setStringList(
      _storageKey,
      _accounts.map((a) => jsonEncode(a.toJson())).toList(),
    );
  }
}
