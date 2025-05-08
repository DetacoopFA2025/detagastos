enum AccountType {
  creditCard,
  cash,
  checkingAccount,
  savingsAccount,
  other,
}

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
}
