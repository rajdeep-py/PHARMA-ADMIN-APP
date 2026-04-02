import 'package:flutter/material.dart';

class AnnouncementCard extends StatelessWidget {
	const AnnouncementCard({
		super.key,
		required this.headline,
		required this.description,
		required this.onEdit,
		required this.onDelete,
	});

	final String headline;
	final String description;
	final VoidCallback onEdit;
	final VoidCallback onDelete;

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
				padding: const EdgeInsets.all(14),
				child: Row(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Container(
							width: 44,
							height: 44,
							decoration: BoxDecoration(
								color: theme.colorScheme.primary.withAlpha(18),
								borderRadius: BorderRadius.circular(16),
								border: Border.all(color: outline),
							),
							child: Icon(
								Icons.campaign_rounded,
								color: theme.colorScheme.primary,
							),
						),
						const SizedBox(width: 12),
						Expanded(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.stretch,
								children: [
									Text(
										headline,
										maxLines: 2,
										overflow: TextOverflow.ellipsis,
										style: theme.textTheme.titleSmall?.copyWith(
											fontWeight: FontWeight.w900,
											letterSpacing: -0.15,
										),
									),
									const SizedBox(height: 4),
									Text(
										description,
										maxLines: 3,
										overflow: TextOverflow.ellipsis,
										style: theme.textTheme.bodySmall?.copyWith(
											color: theme.colorScheme.onSurface.withAlpha(180),
											fontWeight: FontWeight.w700,
										),
									),
								],
							),
						),
						const SizedBox(width: 10),
						IconButton(
							tooltip: 'Edit announcement',
							onPressed: onEdit,
							icon: Icon(
								Icons.edit_rounded,
								color: theme.colorScheme.primary,
							),
						),
						IconButton(
							tooltip: 'Delete announcement',
							onPressed: onDelete,
							icon: Icon(
								Icons.delete_outline_rounded,
								color: theme.colorScheme.error,
							),
						),
					],
				),
			),
		);
	}
}

