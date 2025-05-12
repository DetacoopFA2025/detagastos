import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RangeSelector extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function(DateTimeRange) onDateRangeSelected;

  const RangeSelector(
      {super.key,
      required this.startDate,
      required this.endDate,
      required this.onDateRangeSelected});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: InkWell(
          onTap: () => _selectDateRange(context),
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Rango de fechas',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            child: Text(
              '${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}',
            ),
          ),
        ),
      ),
    ]);
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null) {
      onDateRangeSelected(picked);
    }
  }
}
