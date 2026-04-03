import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';

import '../../models/salary_slip.dart';
import '../../notifiers/salary_slip_notifier.dart';

class ViewSalarySlipBottomSheet extends ConsumerStatefulWidget {
  const ViewSalarySlipBottomSheet({
    super.key,
    required this.employeeType,
    required this.employeeId,
    required this.employeeName,
  });

  final SalarySlipEmployeeType employeeType;
  final String employeeId;
  final String employeeName;

  @override
  ConsumerState<ViewSalarySlipBottomSheet> createState() =>
      _ViewSalarySlipBottomSheetState();
}

class _ViewSalarySlipBottomSheetState
    extends ConsumerState<ViewSalarySlipBottomSheet> {
  late int _month;
  late int _year;
  bool _isOpening = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = now.month;
    _year = now.year;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(102);

    final months = <int, String>{
      1: 'January',
      2: 'February',
      3: 'March',
      4: 'April',
      5: 'May',
      6: 'June',
      7: 'July',
      8: 'August',
      9: 'September',
      10: 'October',
      11: 'November',
      12: 'December',
    };
    final years = <int>[
      for (int y = DateTime.now().year; y >= DateTime.now().year - 6; y--) y,
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Card(
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: outline),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'View Salary Slip',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.employeeType.label} • ${widget.employeeName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(170),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: _month,
                        items: [
                          for (final e in months.entries)
                            DropdownMenuItem(
                              value: e.key,
                              child: Text(e.value),
                            ),
                        ],
                        onChanged: (v) => setState(() => _month = v ?? _month),
                        decoration: const InputDecoration(labelText: 'Month'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: _year,
                        items: [
                          for (final y in years)
                            DropdownMenuItem(
                              value: y,
                              child: Text(y.toString()),
                            ),
                        ],
                        onChanged: (v) => setState(() => _year = v ?? _year),
                        decoration: const InputDecoration(labelText: 'Year'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _isOpening
                      ? null
                      : () async {
                          setState(() => _isOpening = true);
                          try {
                            final slip = await ref
                                .read(salarySlipNotifierProvider.notifier)
                                .findForPeriod(
                                  employeeType: widget.employeeType,
                                  employeeId: widget.employeeId,
                                  month: _month,
                                  year: _year,
                                );

                            if (!context.mounted) return;

                            if (slip == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'No salary slip found for the selected month/year.',
                                  ),
                                ),
                              );
                              return;
                            }

                            final exists = await File(slip.filePath).exists();
                            if (!exists) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'File not found on this device.',
                                  ),
                                ),
                              );
                              return;
                            }

                            final result = await OpenFilex.open(slip.filePath);
                            if (!context.mounted) return;

                            if (result.type != ResultType.done) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    result.message.isEmpty
                                        ? 'Failed to open file.'
                                        : result.message,
                                  ),
                                ),
                              );
                            }
                          } finally {
                            if (mounted) setState(() => _isOpening = false);
                          }
                        },
                  icon: _isOpening
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.open_in_new_rounded),
                  label: const Text('Open'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
