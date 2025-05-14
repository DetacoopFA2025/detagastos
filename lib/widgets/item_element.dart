import 'package:flutter/material.dart';
import 'delete_confirmation_dialog.dart';

class ItemElement extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final String title;
  final String description;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ItemElement({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.title,
    required this.description,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: backgroundColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: backgroundColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _showDeleteConfirmationDialog(context),
                  color: Colors.grey[600],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    const String content =
        'Eliminar esta cuenta, eliminara las transacciones asociadas, ¿Estás seguro de querer eliminar esta cuenta?';

    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        resourceType: 'Cuenta',
        resourceName: title,
        optionalContent: content,
      ),
    );
    if (result == true) {
      onDelete?.call();
    }
  }
}
