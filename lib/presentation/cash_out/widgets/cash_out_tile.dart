import 'package:flutter/material.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../data/database/app_database.dart';
import '../../../data/models/cash_out.dart';

class CashOutTile extends StatelessWidget {
  final CashOutEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CashOutTile({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  IconData _categoryIcon(CashOutCategory category) {
    switch (category) {
      case CashOutCategory.supplierPayment:
        return Icons.inventory;
      case CashOutCategory.personalWithdrawal:
        return Icons.person;
      case CashOutCategory.storeExpenses:
        return Icons.store;
      case CashOutCategory.miscellaneous:
        return Icons.more_horiz;
    }
  }

  Color _categoryColor(CashOutCategory category) {
    switch (category) {
      case CashOutCategory.supplierPayment:
        return Colors.orange;
      case CashOutCategory.personalWithdrawal:
        return Colors.purple;
      case CashOutCategory.storeExpenses:
        return Colors.teal;
      case CashOutCategory.miscellaneous:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = CashOutCategory.values.firstWhere(
      (c) => c.name == entry.category,
      orElse: () => CashOutCategory.miscellaneous,
    );
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _categoryColor(category).withValues(alpha: 0.15),
          child: Icon(
            _categoryIcon(category),
            color: _categoryColor(category),
            size: 20,
          ),
        ),
        title: Text(
          category.displayName,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: entry.description != null && entry.description!.isNotEmpty
            ? Text(
                entry.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              CurrencyFormatter.format(entry.amount),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
