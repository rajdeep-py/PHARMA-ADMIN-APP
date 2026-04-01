import 'package:flutter/material.dart';

class FooterCard extends StatelessWidget {
  const FooterCard({
    super.key,
    this.logoAssetPath = 'assets/logo/naiyo24_logo.png',
  });

  final String logoAssetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(204);

    return Card(
      color: theme.colorScheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: outline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Center(
          child: Image.asset(
            logoAssetPath,
            width: 56,
            height: 56,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
