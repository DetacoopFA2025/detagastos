import 'package:detagastos/services/account_service.dart';
import 'package:flutter/material.dart';

class AccountSelector extends StatelessWidget {
  final String? selectedAccountId;
  final Function(String?) onAccountSelected;

  const AccountSelector({
    super.key,
    this.selectedAccountId,
    required this.onAccountSelected,
  });

  @override
  Widget build(BuildContext context) {
    final AccountService accountService = AccountService();
    return DropdownButtonFormField<String>(
      value: selectedAccountId,
      decoration: const InputDecoration(
        labelText: 'Cuenta',
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem(
          value: null,
          child: Text('Todas las cuentas'),
        ),
        ...accountService.accounts.map((account) {
          return DropdownMenuItem(
            value: account.id,
            child: Text(account.name),
          );
        }),
      ],
      onChanged: (value) {
        onAccountSelected(value);
      },
    );
  }
}
