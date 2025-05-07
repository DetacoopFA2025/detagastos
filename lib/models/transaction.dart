enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category;
  final String? description;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    this.description,
  });

  // Factory constructor for creating a new transaction
  factory Transaction.create({
    required String title,
    required double amount,
    required TransactionType type,
    String? category,
    String? description,
    String? id,
  }) {
    return Transaction(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      date: DateTime.now(),
      type: type,
      category: category ?? '',
      description: description,
    );
  }

  // Convert transaction to a formatted string for display
  String get formattedAmount {
    final prefix = type == TransactionType.income ? '+' : '-';
    return '$prefix\$${amount.toStringAsFixed(0)}';
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
      description: map['description'],
    );
  }
}
