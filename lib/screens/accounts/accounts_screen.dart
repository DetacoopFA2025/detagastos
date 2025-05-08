import 'package:flutter/material.dart';
import '../../models/account.dart';
import '../../services/account_service.dart';
import 'account_screen.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  final AccountService accountService = AccountService();
  List<Account> _accounts = [];

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  void _loadAccounts() {
    setState(() {
      _accounts = accountService.accounts;
    });
  }

  String _getAccountTypeLabel(AccountType type) {
    switch (type) {
      case AccountType.creditCard:
        return 'Tarjeta de crédito';
      case AccountType.cash:
        return 'Efectivo';
      case AccountType.checkingAccount:
        return 'Cuenta corriente';
      case AccountType.savingsAccount:
        return 'Cuenta a la vista';
      case AccountType.other:
        return 'Otros';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuentas'),
      ),
      body: ListView.builder(
        itemCount: _accounts.length,
        itemBuilder: (context, index) {
          final account = _accounts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('${account.name} - ${account.id}'),
              subtitle: Text(_getAccountTypeLabel(account.type)),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountScreen(
                      account: account,
                    ),
                  ),
                );
                _loadAccounts();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountScreen(),
            ),
          );
          _loadAccounts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
