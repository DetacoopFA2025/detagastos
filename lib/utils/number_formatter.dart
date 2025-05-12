class NumberFormatter {
  static String formatCompact(double number) {
    final absNumber = number.abs();
    final isNegative = number < 0;
    if (absNumber >= 1000000) {
      return '${isNegative ? '-' : ''}\$${(absNumber / 1000000).toStringAsFixed(1)} millones';
    } else if (absNumber >= 1000) {
      return '${isNegative ? '-' : ''}\$${(absNumber / 1000).toStringAsFixed(1)} mil';
    } else {
      return '${isNegative ? '-' : ''}\$${absNumber.toStringAsFixed(0)}';
    }
  }

  static String formatWithSeparator(double number) {
    final isNegative = number < 0;
    final absNumber = number.abs();
    final parts = absNumber.toStringAsFixed(0).split('.');
    final wholePart = parts[0];

    final formattedWholePart = wholePart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );

    return '${isNegative ? '-' : ''}\$$formattedWholePart';
  }
}
