
import 'dart:typed_data';

import 'package:flutter/material.dart';

class TeamCard extends StatelessWidget {
	const TeamCard({
		super.key,
		required this.photoBytes,
		required this.teamName,
		required this.teamDescription,
		required this.onTap,
		required this.onEdit,
		required this.onDelete,
	});

	final Uint8List? photoBytes;
	final String teamName;
	final String teamDescription;
	final VoidCallback onTap;
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
			child: InkWell(
				onTap: onTap,
				borderRadius: BorderRadius.circular(24),
				child: Padding(
					padding: const EdgeInsets.all(14),
					child: Row(
						children: [
							_TeamAvatar(photoBytes: photoBytes),
							const SizedBox(width: 12),
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											teamName,
											maxLines: 1,
											overflow: TextOverflow.ellipsis,
											style: theme.textTheme.titleSmall?.copyWith(
												fontWeight: FontWeight.w900,
												letterSpacing: -0.15,
											),
										),
										const SizedBox(height: 6),
										Text(
											teamDescription,
											maxLines: 2,
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
							IconButton(
								tooltip: 'Edit Team',
								onPressed: onEdit,
								icon: Icon(
									Icons.edit_rounded,
									color: theme.colorScheme.primary,
								),
							),
							IconButton(
								tooltip: 'Delete Team',
								onPressed: onDelete,
								icon: Icon(
									Icons.delete_outline_rounded,
									color: theme.colorScheme.error,
								),
							),
						],
					),
				),
			),
		);
	}
}

class _TeamAvatar extends StatelessWidget {
	const _TeamAvatar({required this.photoBytes});

	final Uint8List? photoBytes;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		final image = (photoBytes == null)
				? null
				: ClipRRect(
						borderRadius: BorderRadius.circular(18),
						child: Image.memory(
							photoBytes!,
							width: 56,
							height: 56,
							fit: BoxFit.cover,
						),
					);

		return Container(
			width: 60,
			height: 60,
			padding: const EdgeInsets.all(2),
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(20),
				border: Border.all(color: outline),
			),
			child: (image != null)
					? image
					: Container(
							decoration: BoxDecoration(
								borderRadius: BorderRadius.circular(18),
								color: theme.colorScheme.primary.withAlpha(14),
							),
							child: Icon(
								Icons.hub_rounded,
								color: theme.colorScheme.primary,
							),
						),
		);
	}
}

