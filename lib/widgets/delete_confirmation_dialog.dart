import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String resourceType;
  final String resourceName;
  final String? optionalContent;

  const DeleteConfirmationDialog({
    super.key,
    required this.resourceType,
    required this.resourceName,
    this.optionalContent,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar eliminación'),
      content: optionalContent != null
          ? Text(optionalContent!)
          : Text(
              '¿Estás seguro que deseas eliminar $resourceType "$resourceName"?',
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}
