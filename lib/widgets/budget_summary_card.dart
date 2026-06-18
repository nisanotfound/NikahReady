import 'package:flutter/material.dart';

/// Top-of-screen summary card for the Wedding Planner's "Budget" tab:
/// total budget, amount spent, remaining balance, and a progress bar.
class BudgetSummaryCard extends StatelessWidget {
  final double totalBudget;
  final double totalSpent;
  final double remaining;
  final double usedFraction;
  final VoidCallback onEditBudget;

  const BudgetSummaryCard({
    super.key,
    required this.totalBudget,
    required this.totalSpent,
    required this.remaining,
    required this.usedFraction,
    required this.onEditBudget,
  });

  String _fmt(double v) => 'RM ${v.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overBudget = remaining < 0;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Wedding Budget', style: theme.textTheme.titleMedium),
                TextButton(onPressed: onEditBudget, child: const Text('Edit')),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _fmt(totalBudget),
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: usedFraction.toDouble(),
                minHeight: 10,
                backgroundColor: theme.colorScheme.surfaceVariant,
                color: overBudget ? theme.colorScheme.error : theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Spent: ${_fmt(totalSpent)}', style: theme.textTheme.bodyMedium),
                Text(
                  overBudget
                      ? 'Over by ${_fmt(remaining.abs())}'
                      : 'Remaining: ${_fmt(remaining)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: overBudget ? theme.colorScheme.error : Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
