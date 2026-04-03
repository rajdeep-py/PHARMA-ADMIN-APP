import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/salary_slip.dart';
import '../../notifiers/salary_slip_notifier.dart';

class UploadSalarySlipBottomSheet extends ConsumerStatefulWidget {
  const UploadSalarySlipBottomSheet({
    super.key,
    required this.employeeType,
    required this.employeeId,
    required this.employeeName,
  });

  final SalarySlipEmployeeType employeeType;
  final String employeeId;
  final String employeeName;

  @override
  ConsumerState<UploadSalarySlipBottomSheet> createState() =>
      _UploadSalarySlipBottomSheetState();
}

class _UploadSalarySlipBottomSheetState
    extends ConsumerState<UploadSalarySlipBottomSheet> {
  late int _month;
  late int _year;
  bool _isUploading = false;

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
                      Icons.upload_file_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Upload Salary Slip',
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
                  onPressed: _isUploading
                      ? null
                      : () async {
                          setState(() => _isUploading = true);
                          try {
                            final result = await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                              type: FileType.custom,
                              allowedExtensions: const [
                                'pdf',
                                'jpg',
                                'jpeg',
                                'png',
                              ],
                              dialogTitle: 'Select salary slip file',
                            );

                            final file = result?.files.single;
                            final filePath = file?.path;
                            if (file == null || filePath == null) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No file selected.'),
                                ),
                              );
                              return;
                            }

                            await ref
                                .read(salarySlipNotifierProvider.notifier)
                                .upload(
                                  employeeType: widget.employeeType,
                                  employeeId: widget.employeeId,
                                  month: _month,
                                  year: _year,
                                  filePath: filePath,
                                  fileName: file.name,
                                );

                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Uploaded: ${file.name}')),
                            );
                          } finally {
                            if (mounted) setState(() => _isUploading = false);
                          }
                        },
                  icon: _isUploading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.upload_file_rounded),
                  label: const Text('Upload'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
