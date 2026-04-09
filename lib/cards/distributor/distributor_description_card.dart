import 'package:flutter/material.dart';

class DistributorDescriptionCard extends StatelessWidget {
	const DistributorDescriptionCard({
		super.key,
		required this.description,
	});

	final String description;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		String normalize(String v) {
			final t = v.trim();
			return t.isEmpty ? '-' : t;
		}

		return Card(
			elevation: 0,
			surfaceTintColor: Colors.transparent,
			color: theme.colorScheme.surface,
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(24),
				side: BorderSide(color: outline),
			),
			child: Padding(
				padding: const EdgeInsets.all(16),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(
							'Description',
							style: theme.textTheme.titleMedium?.copyWith(
								fontWeight: FontWeight.w900,
								letterSpacing: -0.2,
							),
						),
						const SizedBox(height: 10),
						Text(
							normalize(description),
							style: theme.textTheme.bodyMedium?.copyWith(
								fontWeight: FontWeight.w700,
								height: 1.25,
								color: theme.colorScheme.onSurface.withAlpha(191),
							),
						),
					],
				),
			),
		);
	}
}

