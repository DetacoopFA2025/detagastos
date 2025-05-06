class Category {
  final String name;
  final String emoji;
  final bool isExpense;

  const Category({
    required this.name,
    required this.emoji,
    required this.isExpense,
  });

  @override
  String toString() => '$emoji $name';
}
