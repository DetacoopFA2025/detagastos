import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../services/category_service.dart';

class CreateCategoryScreen extends StatefulWidget {
  final bool isExpense;
  final Category? initialCategory;

  const CreateCategoryScreen({
    super.key,
    required this.isExpense,
    this.initialCategory,
  });

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emojiController = TextEditingController();
  bool _isLoading = false;
  final _categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _nameController.text = widget.initialCategory!.name;
      _emojiController.text = widget.initialCategory!.emoji;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final category = Category(
          name: _nameController.text,
          emoji: _emojiController.text,
          isExpense: widget.isExpense,
        );

        if (widget.initialCategory != null) {
          // Si estamos editando, primero eliminamos la categoría anterior
          await _categoryService.removeCategory(widget.initialCategory!);
        }

        await _categoryService.addCategory(category);

        if (mounted) {
          // Clear form
          _formKey.currentState!.reset();
          _nameController.clear();
          _emojiController.clear();

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.initialCategory != null
                  ? 'Categoría actualizada exitosamente'
                  : 'Categoría creada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate back with the new/updated category
          Navigator.pop(context, category);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar la categoría: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialCategory != null
            ? 'Editar Categoría'
            : 'Nueva Categoría de ${widget.isExpense ? 'Gasto' : 'Ingreso'}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ej: Supermercado, Gasolina, etc.',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Emoji Field
              TextFormField(
                controller: _emojiController,
                decoration: const InputDecoration(
                  labelText: 'Emoji',
                  hintText: 'Seleccione un emoji',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                maxLength: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione un emoji';
                  }
                  // Validar que sean uno o dos emojis
                  final emojiRegex = RegExp(
                    r'^[\p{Emoji}\p{Emoji_Presentation}\p{Emoji_Modifier}\p{Emoji_Component}\p{Extended_Pictographic}]{1,2}$',
                    unicode: true,
                  );
                  if (!emojiRegex.hasMatch(value)) {
                    return 'Por favor ingrese uno o dos emojis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              FilledButton.icon(
                onPressed: _isLoading ? null : _submitForm,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isLoading
                    ? 'Guardando...'
                    : widget.initialCategory != null
                        ? 'Actualizar Categoría'
                        : 'Guardar Categoría'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
