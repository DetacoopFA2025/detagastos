import 'package:flutter/material.dart';
import '../../models/account.dart';
import '../../services/account_service.dart';

class AccountScreen extends StatefulWidget {
  final Account? account;

  const AccountScreen({
    super.key,
    this.account,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late AccountType _selectedType;
  final AccountService accountService = AccountService();
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account?.name ?? '');
    _selectedType = widget.account?.type ?? AccountType.other;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveAccount() async {
    if (_formKey.currentState!.validate()) {
      final account = Account.create(
        id: widget.account?.id,
        name: _nameController.text,
        type: _selectedType,
      );

      if (widget.account == null) {
        await accountService.addAccount(account);
      } else {
        await accountService.updateAccount(account);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _deleteAccount() async {
    if (widget.account != null) {
      await accountService.removeAccount(widget.account!.id);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.account == null ? 'Nueva Cuenta' : 'Editar Cuenta'),
        actions: [
          if (widget.account != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteAccount,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ej: Banco de Chile, Billetera, etc.',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<AccountType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Tipo de cuenta',
                  border: OutlineInputBorder(),
                ),
                items: AccountType.values.map((type) {
                  String label;
                  switch (type) {
                    case AccountType.creditCard:
                      label = 'Tarjeta de crédito';
                      break;
                    case AccountType.cash:
                      label = 'Efectivo';
                      break;
                    case AccountType.checkingAccount:
                      label = 'Cuenta corriente';
                      break;
                    case AccountType.savingsAccount:
                      label = 'Cuenta a la vista';
                      break;
                    case AccountType.other:
                      label = 'Otros';
                      break;
                  }
                  return DropdownMenuItem(
                    value: type,
                    child: Text(label),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _saveAccount,
                label: Text(widget.account == null ? 'Crear' : 'Guardar'),
                icon: const Icon(Icons.save),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
