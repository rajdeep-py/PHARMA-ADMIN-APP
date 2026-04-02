
import 'dart:typed_data';

import 'package:flutter/material.dart';

class TeamHeaderCard extends StatelessWidget {
	const TeamHeaderCard({
		super.key,
		required this.photoBytes,
		required this.teamName,
		required this.memberCount,
	});

	final Uint8List? photoBytes;
	final String teamName;
	final int memberCount;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);
		final onSurface = theme.colorScheme.onSurface;

		return Card(
			elevation: 0,
			surfaceTintColor: Colors.transparent,
			color: theme.colorScheme.surface,
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(24),
				side: BorderSide(color: outline),
			),
			clipBehavior: Clip.antiAlias,
			child: SizedBox(
				height: 190,
				child: Stack(
					fit: StackFit.expand,
					children: [
						if (photoBytes != null)
							Image.memory(photoBytes!, fit: BoxFit.cover)
						else
							DecoratedBox(
								decoration: BoxDecoration(
									gradient: LinearGradient(
										begin: Alignment.topLeft,
										end: Alignment.bottomRight,
										colors: [
											theme.colorScheme.primary.withAlpha(26),
											theme.colorScheme.surfaceContainerHighest,
										],
									),
								),
							),
						Positioned.fill(
							child: DecoratedBox(
								decoration: BoxDecoration(
									gradient: LinearGradient(
										begin: Alignment.topCenter,
										end: Alignment.bottomCenter,
										colors: [
											Colors.transparent,
											onSurface.withAlpha(180),
										],
									),
								),
							),
            ),
						Positioned(
							left: 16,
							right: 16,
							bottom: 16,
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										teamName,
										maxLines: 1,
										overflow: TextOverflow.ellipsis,
										style: theme.textTheme.titleLarge?.copyWith(
											color: theme.colorScheme.surface,
											fontWeight: FontWeight.w900,
											letterSpacing: -0.3,
										),
									),
									const SizedBox(height: 6),
									Text(
										'$memberCount members',
										style: theme.textTheme.bodyMedium?.copyWith(
											color: theme.colorScheme.surface.withAlpha(230),
											fontWeight: FontWeight.w800,
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

