import 'package:detagastos/models/transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieSection extends StatefulWidget {
  final List<Transaction> transactions;
  final List<MapEntry<String, double>> sortedCategories;

  const PieSection(
      {super.key, required this.transactions, required this.sortedCategories});

  @override
  State<PieSection> createState() => _PieSectionState();
}

class _PieSectionState extends State<PieSection> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1.5,
                  child: PieChart(
                    PieChartData(
                      sections:
                          _createPieChartSections(widget.sortedCategories),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      startDegreeOffset: -90,
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              _touchedIndex = null;
                              return;
                            }
                            _touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Total: \$${widget.transactions.fold<double>(0, (sum, t) => sum + t.amount).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Leyenda
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.sortedCategories.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final category = widget.sortedCategories[index];
              final percentage = (category.value /
                      widget.transactions.fold(0, (sum, t) => sum + t.amount)) *
                  100;
              return ListTile(
                leading: CircleAvatar(
                  radius: 12,
                  backgroundColor: _getCategoryColor(index),
                ),
                title: Text(
                  category.key,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${category.value.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _createPieChartSections(
      List<MapEntry<String, double>> categories) {
    final total =
        categories.fold<double>(0, (sum, category) => sum + category.value);

    return List.generate(categories.length, (index) {
      final category = categories[index];
      final percentage = (category.value / total) * 100;
      final isTouched = index == _touchedIndex;
      final isTopThree = index < 3;

      return PieChartSectionData(
        color: _getCategoryColor(index),
        value: category.value,
        title: isTouched
            ? '\$${category.value.toStringAsFixed(0)}'
            : (isTopThree ? category.key : ''),
        radius: isTouched ? 75 : 70,
        titleStyle: TextStyle(
          fontSize: isTouched ? 14 : 12,
          fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withAlpha(77),
              offset: const Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
        titlePositionPercentageOffset: 0.5,
        borderSide: BorderSide(
          color: Colors.white.withAlpha(51),
          width: 1,
        ),
      );
    });
  }

  Color _getCategoryColor(int index) {
    const baseColor = Color.fromRGBO(4, 60, 92, 1);
    final colors = [
      baseColor,
      const Color.fromRGBO(4, 60, 92, 0.9),
      const Color.fromRGBO(4, 80, 120, 1),
      const Color.fromRGBO(4, 60, 92, 0.7),
      const Color.fromRGBO(4, 100, 150, 1),
      const Color.fromRGBO(4, 60, 92, 0.5),
      const Color.fromRGBO(4, 120, 180, 1),
      const Color.fromRGBO(4, 60, 92, 0.3),
      const Color.fromRGBO(4, 140, 210, 1),
      const Color.fromRGBO(4, 60, 92, 0.1),
    ];
    return colors[index % colors.length];
  }
}
