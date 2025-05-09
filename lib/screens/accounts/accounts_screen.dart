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
            icon: account.typeIcon,
            backgroundColor: account.typeColor,
            title: account.name,
            description: account.typeLabel,
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
