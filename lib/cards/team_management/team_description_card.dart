
import 'package:flutter/material.dart';

class TeamDescriptionCard extends StatelessWidget {
	const TeamDescriptionCard({
		super.key,
		required this.description,
	});

	final String description;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

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
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Row(
							children: [
								Icon(
									Icons.subject_rounded,
									color: theme.colorScheme.primary,
								),
								const SizedBox(width: 10),
								Text(
									'Team description',
									style: theme.textTheme.titleSmall?.copyWith(
										fontWeight: FontWeight.w900,
									),
								),
							],
						),
						const SizedBox(height: 10),
						Text(
							description.trim().isEmpty ? 'No description provided.' : description,
							style: theme.textTheme.bodyMedium?.copyWith(
								color: theme.colorScheme.onSurface.withAlpha(200),
								fontWeight: FontWeight.w700,
								height: 1.4,
							),
						),
					],
				),
			),
		);
	}
}

