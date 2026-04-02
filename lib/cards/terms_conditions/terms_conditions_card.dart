import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class TermsConditionsCard extends StatelessWidget {
  const TermsConditionsCard({
    super.key,
    required this.header,
    required this.description,
  });

  final String header;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(204);

    return Card(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              header,
              style: theme.textTheme.tagline.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.description.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(191),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
