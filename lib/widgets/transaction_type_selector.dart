import 'package:detagastos/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionTypeSelector extends StatefulWidget {
  final TransactionType selectedType;
  final Function(TransactionType) onTypeSelected;

  const TransactionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  State<TransactionTypeSelector> createState() =>
      _TransactionTypeSelectorState();
}

class _TransactionTypeSelectorState extends State<TransactionTypeSelector> {
  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TransactionType>(
      style: SegmentedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      segments: const [
        ButtonSegment<TransactionType>(
          value: TransactionType.expense,
          label: Text('Gasto'),
          icon: Icon(Icons.trending_down_rounded),
        ),
        ButtonSegment<TransactionType>(
          value: TransactionType.income,
          label: Text('Ingreso'),
          icon: Icon(Icons.trending_up_rounded),
        ),
      ],
      selected: {widget.selectedType},
      onSelectionChanged: (Set<TransactionType> selected) {
        widget.onTypeSelected(selected.first);
      },
    );
  }
}
