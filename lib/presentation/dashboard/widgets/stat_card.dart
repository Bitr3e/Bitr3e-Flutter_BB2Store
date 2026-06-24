import 'package:flutter/material.dart';

import '../../../core/utils/currency_formatter.dart';

class StatCard extends StatelessWidget {
  final String title;
  final int amount;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool isLoading;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = backgroundColor ?? theme.cardColor;

    return Card(
      color: cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: iconColor ?? theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (isLoading)
              const LinearProgressIndicator()
            else
              Text(
                CurrencyFormatter.format(amount),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: amount < 0
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurface,
                ),
              ),
          ],
        ),
      ),
      ),
    );
  }
}
