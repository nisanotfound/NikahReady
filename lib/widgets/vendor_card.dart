import 'package:flutter/material.dart';

import '../models/vendor_model.dart';

/// A card showing one vendor's details with inline status switching and
/// a delete action — used in the Wedding Planner's "Vendors" tab.
class VendorCard extends StatelessWidget {
  final Vendor vendor;
  final ValueChanged<VendorStatus> onStatusChanged;
  final VoidCallback onDelete;

  const VendorCard({
    super.key,
    required this.vendor,
    required this.onStatusChanged,
    required this.onDelete,
  });

  Color _colorFor(VendorStatus status, ColorScheme scheme) {
    switch (status) {
      case VendorStatus.contacted:
        return Colors.blueGrey;
      case VendorStatus.booked:
        return Colors.amber.shade800;
      case VendorStatus.confirmed:
        return scheme.primary;
      case VendorStatus.cancelled:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final statusColor = _colorFor(vendor.status, scheme);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: statusColor.withOpacity(0.15),
              child: Icon(Icons.store_mall_directory_outlined, color: statusColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vendor.name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    vendor.serviceType,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 2),
                  Text(vendor.contact, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: VendorStatus.values.map((s) {
                      final selected = s == vendor.status;
                      final color = _colorFor(s, scheme);
                      return ChoiceChip(
                        label: Text(s.label, style: const TextStyle(fontSize: 11)),
                        selected: selected,
                        onSelected: (_) => onStatusChanged(s),
                        selectedColor: color.withOpacity(0.18),
                        labelStyle: TextStyle(color: selected ? color : Colors.grey[700]),
                        side: BorderSide(color: selected ? color : Colors.grey[300]!),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.grey,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
