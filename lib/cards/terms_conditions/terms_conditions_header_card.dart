import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class TermsConditionsHeaderCard extends StatelessWidget {
  const TermsConditionsHeaderCard({
    super.key,
    this.logoAssetPath = 'assets/logo/naiyo24_logo.png',
    this.companyName = 'Naiyo24',
    this.tagline = 'MR Management App',
  });

  final String logoAssetPath;
  final String companyName;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final outline = theme.colorScheme.outline.withAlpha(204);

    return Card(
      color: surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: theme.colorScheme.outline.withAlpha(102),
                ),
              ),
              child: Center(
                child: Image.asset(
                  logoAssetPath,
                  width: 34,
                  height: 34,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    companyName,
                    style: theme.textTheme.tagline.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tagline,
                    style: theme.textTheme.description.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(191),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
