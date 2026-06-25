import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/database/app_database.dart';
import '../../../data/models/cash_out.dart';

class CashOutFormDialog extends StatefulWidget {
  final CashOutEntry? existingEntry;

  const CashOutFormDialog({super.key, this.existingEntry});

  @override
  State<CashOutFormDialog> createState() => _CashOutFormDialogState();
}

class _CashOutFormDialogState extends State<CashOutFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late CashOutCategory _selectedCategory;

  bool get isEditing => widget.existingEntry != null;

  @override
  void initState() {
    super.initState();
    final entry = widget.existingEntry;
    _amountController = TextEditingController(
      text: entry != null ? entry.amount.toString() : '',
    );
    _descriptionController = TextEditingController(
      text: entry?.description ?? '',
    );
    _selectedCategory = entry != null
        ? CashOutCategory.values.firstWhere(
            (c) => c.name == entry.category,
            orElse: () => CashOutCategory.miscellaneous,
          )
        : CashOutCategory.miscellaneous;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Cash-Out' : 'Add Cash-Out'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '₱ ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = int.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CashOutCategory>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
                items: CashOutCategory.values.map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Text(c.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final amount = int.parse(_amountController.text);
    Navigator.of(context).pop({
      'amount': amount,
      'category': _selectedCategory,
      'description': _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null,
    });
  }
}
