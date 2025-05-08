import 'package:flutter/material.dart';
import '../../models/account.dart';
import '../../services/account_service.dart';
import '../../widgets/item_element.dart';
import 'account_screen.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  List<Account> _accounts = [];

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  void _loadAccounts() {
    setState(() {
      _accounts = AccountService().accounts;
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

  IconData _getAccountTypeIcon(AccountType type) {
    switch (type) {
      case AccountType.creditCard:
        return Icons.credit_card;
      case AccountType.cash:
        return Icons.money;
      case AccountType.checkingAccount:
        return Icons.account_balance;
      case AccountType.savingsAccount:
        return Icons.savings;
      case AccountType.other:
        return Icons.account_balance_wallet;
    }
  }

  Color _getAccountTypeColor(AccountType type) {
    switch (type) {
      case AccountType.creditCard:
        return Colors.blue;
      case AccountType.cash:
        return Colors.green;
      case AccountType.checkingAccount:
        return Colors.orange;
      case AccountType.savingsAccount:
        return Colors.purple;
      case AccountType.other:
        return Colors.grey;
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
          return ItemElement(
            icon: _getAccountTypeIcon(account.type),
            backgroundColor: _getAccountTypeColor(account.type),
            title: account.name,
            description: _getAccountTypeLabel(account.type),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountScreen(account: account),
                ),
              );
              _loadAccounts();
            },
            onDelete: () async {
              await AccountService().removeAccount(account.id);
              _loadAccounts();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountScreen(),
            ),
          );
          _loadAccounts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
