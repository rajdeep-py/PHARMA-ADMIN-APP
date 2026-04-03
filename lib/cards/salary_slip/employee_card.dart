import 'package:flutter/material.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.onUpload,
    required this.onView,
  });

  final String name;
  final String phoneNumber;
  final String email;

  final VoidCallback onUpload;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(102);

    final resolvedEmail = email.trim().isEmpty ? '-' : email.trim();

    return Card(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: theme.colorScheme.primary.withAlpha(14),
                border: Border.all(color: outline),
              ),
              child: Icon(
                Icons.person_rounded,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    phoneNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(170),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    resolvedEmail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(170),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton.icon(
                  onPressed: onUpload,
                  icon: const Icon(Icons.upload_file_rounded),
                  label: const Text('Upload'),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: onView,
                  icon: const Icon(Icons.visibility_rounded),
                  label: const Text('View'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
