import 'package:flutter/material.dart';
import '../models/wedding_models.dart';

/// Opens a modal dialog to set or update the total maximum wedding budget allocation.
Future<double?> showSetBudgetDialog(BuildContext context, double current) {
  final controller = TextEditingController(
    text: current > 0 ? current.toStringAsFixed(0) : '',
  );
  return showDialog<double>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Set Total Budget'),
      content: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        autofocus: true,
        decoration: const InputDecoration(prefixText: 'RM ', labelText: 'Total budget'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final value = double.tryParse(controller.text.trim());
            Navigator.pop(context, value);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

/// A temporary draft data schema container used to collect and transfer new expense entries.
class ExpenseDraft {
  final String category;
  final String description;
  final double amount;
  ExpenseDraft(this.category, this.description, this.amount);
}

/// Opens a validated form modal overlay to append a brand new wedding expenditure log.
Future<ExpenseDraft?> showAddExpenseDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final descController = TextEditingController();
  final amountController = TextEditingController();
  String category = expenseCategories.first;

  return showDialog<ExpenseDraft>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Add Expense'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: expenseCategories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => category = v ?? category),
              ),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(prefixText: 'RM ', labelText: 'Amount'),
                validator: (v) {
                  final parsed = double.tryParse(v ?? '');
                  if (parsed == null || parsed <= 0) return 'Enter a valid amount';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(
                  context,
                  ExpenseDraft(
                    category,
                    descController.text.trim(),
                    double.parse(amountController.text.trim()),
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    ),
  );
}

/// A temporary draft data schema container used to hold and map newly created checklist milestones.
class TaskDraft {
  final String title;
  final DateTime dueDate;
  TaskDraft(this.title, this.dueDate);
}

/// Opens an interactive calendar-linked modal form to allocate scheduled event responsibilities.
Future<TaskDraft?> showAddTaskDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  DateTime dueDate = DateTime.now().add(const Duration(days: 7));

  return showDialog<TaskDraft>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Add Task'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Task Description'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}'),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: dueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 730)),
                      );
                      if (picked != null) setState(() => dueDate = picked);
                    },
                    child: const Text('Change date'),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, TaskDraft(titleController.text.trim(), dueDate));
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    ),
  );
}

/// Opens a dynamic state form modal to register a guest invitation profile along with their initial RSVP status.
Future<Map<String, String>?> showAddGuestDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String status = 'Pending';

  return showDialog<Map<String, String>>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Add Guest'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Guest Full Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(labelText: 'RSVP Status'),
                items: ['Confirmed', 'Pending', 'Declined']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => status = v ?? status),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, {
                  'name': nameController.text.trim(),
                  'status': status,
                });
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
}