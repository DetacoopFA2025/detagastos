import 'package:flutter/material.dart';

enum AccountType {
  creditCard,
  cash,
  checkingAccount,
  savingsAccount,
  other,
}

class AccountTypeConfig {
  final String label;
  final IconData icon;
  final Color color;

  AccountTypeConfig(
      {required this.label, required this.icon, required this.color});
}

Map<AccountType, AccountTypeConfig> accountTypeConfig = {
  AccountType.creditCard: AccountTypeConfig(
    label: 'Tarjeta de crédito',
    icon: Icons.credit_card,
    color: Colors.blue,
  ),
  AccountType.cash: AccountTypeConfig(
    label: 'Efectivo',
    icon: Icons.money,
    color: Colors.green,
  ),
  AccountType.checkingAccount: AccountTypeConfig(
    label: 'Cuenta corriente',
    icon: Icons.account_balance,
    color: Colors.orange,
  ),
  AccountType.savingsAccount: AccountTypeConfig(
    label: 'Cuenta a la vista',
    icon: Icons.savings,
    color: Colors.purple,
  ),
  AccountType.other: AccountTypeConfig(
    label: 'Otros',
    icon: Icons.account_balance_wallet,
    color: Colors.grey,
  ),
};

class Account {
  final String id;
  final String name;
  final AccountType type;

  Account({
    required this.id,
    required this.name,
    required this.type,
  });

  factory Account.create({
    required String name,
    required AccountType type,
    String? id,
  }) {
    return Account(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      type: AccountType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
    );
  }

  String get typeLabel {
    return accountTypeConfig[type]?.label ?? 'Otros';
  }

  IconData get typeIcon {
    return accountTypeConfig[type]?.icon ?? Icons.account_balance_wallet;
  }

  Color get typeColor {
    return accountTypeConfig[type]?.color ?? Colors.grey;
  }
}
