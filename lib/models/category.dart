enum CategoryType {
  expense,
  income,
}

class Category {
  final String name;
  final String emoji;
  final bool isExpense;

  const Category({
    required this.name,
    required this.emoji,
    required this.isExpense,
  });

  CategoryType get type =>
      isExpense ? CategoryType.expense : CategoryType.income;

  @override
  String toString() => '$emoji $name';
}
