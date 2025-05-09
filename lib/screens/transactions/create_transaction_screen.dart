import 'package:detagastos/models/account.dart';
import 'package:detagastos/services/account_service.dart';
import 'package:detagastos/widgets/transaction_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/transaction.dart';
import '../../models/category.dart';
import '../../services/transaction_service.dart';
import '../../services/category_service.dart';
import '../../widgets/delete_confirmation_dialog.dart';

class CreateTransactionScreen extends StatefulWidget {
  final TransactionType? initialType;
  final Transaction? initialTransaction;

  const CreateTransactionScreen({
    super.key,
    this.initialType,
    this.initialTransaction,
  });

  @override
  State<CreateTransactionScreen> createState() =>
      _CreateTransactionScreenState();
}

class _CreateTransactionScreenState extends State<CreateTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  late TransactionType _selectedType;
  Category? _selectedCategory;
  Account? _selectedAccount;
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();
  final _categoryService = CategoryService();
  final _transactionService = TransactionService();
  final _accountService = AccountService();

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType ?? TransactionType.expense;
    final isExpense = _selectedType == TransactionType.expense;

    if (widget.initialTransaction != null) {
      _titleController.text = widget.initialTransaction!.title;
      _amountController.text = widget.initialTransaction!.amount.toString();
      _descriptionController.text =
          widget.initialTransaction!.description ?? '';
      _selectedDate = widget.initialTransaction!.date;
      _selectedCategory = _categoryService.getCategoryByName(
          widget.initialTransaction!.category, isExpense);
      _selectedAccount =
          _accountService.getAccountById(widget.initialTransaction!.accountId);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _selectedAccount = null;
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final transaction = Transaction.create(
          title: _titleController.text,
          amount: double.parse(_amountController.text),
          type: _selectedType,
          category: _selectedCategory?.name,
          accountId: _selectedAccount!.id,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
          id: widget.initialTransaction?.id,
          date: _selectedDate,
        );

        if (widget.initialTransaction != null) {
          await _transactionService
              .removeTransaction(widget.initialTransaction!.id);
        }

        await _transactionService.addTransaction(transaction);

        if (mounted) {
          // Clear form
          _formKey.currentState!.reset();
          _titleController.clear();
          _amountController.clear();
          _descriptionController.clear();
          setState(() {
            _selectedCategory = null;
          });

          if (widget.initialTransaction == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Transacción creada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
          }

          // Navigate back
          Navigator.pop(context, transaction);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar la transacción: $e'),
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

  Future<void> _deleteTransaction() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        resourceType: 'transacción',
        resourceName: widget.initialTransaction!.title,
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await _transactionService
            .removeTransaction(widget.initialTransaction!.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transacción eliminada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar la transacción: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialTransaction != null
            ? 'Editar Transacción'
            : 'Nueva Transacción'),
        actions: [
          if (widget.initialTransaction != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteTransaction(),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Transaction Type Selector
              TransactionTypeSelector(
                selectedType: _selectedType,
                onTypeSelected: (type) {
                  setState(() {
                    _selectedType = type;
                  });
                },
              ),
              const SizedBox(height: 24),
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  hintText: _selectedType == TransactionType.expense
                      ? 'Ej: Supermercado, Gasolina, etc.'
                      : 'Ej: Salario, Venta, etc.',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Amount Field
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Monto',
                  hintText: '0.00',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un monto';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingrese un monto válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<Account>(
                value: _selectedAccount,
                decoration: const InputDecoration(
                  labelText: 'Cuenta',
                  border: OutlineInputBorder(),
                ),
                items: _accountService.accounts
                    .map((account) => DropdownMenuItem(
                          value: account,
                          child: Text(account.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAccount = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione una cuenta';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date Picker Field
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: (_selectedType == TransactionType.expense
                        ? _categoryService.getExpenseCategories()
                        : _categoryService.getIncomeCategories())
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione una categoría';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  hintText: 'Añada detalles adicionales...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
                    : 'Guardar ${_selectedType == TransactionType.expense ? 'Gasto' : 'Ingreso'}'),
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
