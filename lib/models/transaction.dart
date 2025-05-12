enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category;
  final String accountId;
  final String? description;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    required this.accountId,
    this.description,
  });

  // Factory constructor for creating a new transaction
  factory Transaction.create({
    required String title,
    required double amount,
    required TransactionType type,
    required String accountId,
    String? category,
    String? description,
    String? id,
    DateTime? date,
  }) {
    return Transaction(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      date: date ?? DateTime.now(),
      type: type,
      category: category ?? '',
      accountId: accountId,
      description: description,
    );
  }

  double get signedAmount {
    return type == TransactionType.income ? amount : -amount;
  }

  String formatDate() {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Convert transaction to a map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.toString(),
      'category': category,
      'accountId': accountId,
      'description': description,
    };
  }

  // Create a transaction from a map
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == map['type'],
      ),
      category: map['category'],
      accountId: map['accountId'],
      description: map['description'],
    );
  }
}
