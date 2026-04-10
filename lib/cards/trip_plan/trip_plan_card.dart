import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../models/trip_plan.dart';

class TripPlanCard extends StatelessWidget {
	const TripPlanCard({
		super.key,
		required this.subjectType,
		required this.name,
		required this.phoneNumber,
		required this.headquarter,
		required this.photoBytes,
		required this.onTap,
	});

	final TripPlanSubjectType subjectType;
	final String name;
	final String phoneNumber;
	final String headquarter;
	final Uint8List? photoBytes;
	final VoidCallback onTap;

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
				borderRadius: BorderRadius.circular(24),
				onTap: onTap,
				child: Padding(
					padding: const EdgeInsets.all(14),
					child: Row(
						children: [
							_Avatar(
								name: name,
								photoBytes: photoBytes,
								outline: outline,
							),
							const SizedBox(width: 12),
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Row(
											children: [
												Expanded(
													child: Text(
														name,
														maxLines: 1,
														overflow: TextOverflow.ellipsis,
														style: theme.textTheme.titleMedium?.copyWith(
															fontWeight: FontWeight.w900,
															letterSpacing: -0.2,
														),
													),
												),
												const SizedBox(width: 10),
												_TypeChip(type: subjectType),
											],
										),
										const SizedBox(height: 6),
										Wrap(
											spacing: 10,
											runSpacing: 8,
											children: [
												_TextPill(label: phoneNumber),
												_TextPill(label: headquarter),
											],
										),
									],
								),
							),
							const SizedBox(width: 10),
							Icon(
								Icons.arrow_forward_ios_rounded,
								size: 16,
								color: theme.colorScheme.onSurface.withAlpha(166),
							),
						],
					),
				),
			),
		);
	}
}

class _Avatar extends StatelessWidget {
	const _Avatar({
		required this.name,
		required this.photoBytes,
		required this.outline,
	});

	final String name;
	final Uint8List? photoBytes;
	final Color outline;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final initial = name.trim().isEmpty ? '?' : name.trim().substring(0, 1).toUpperCase();

		Widget child;
		if (photoBytes != null) {
			child = ClipRRect(
				borderRadius: BorderRadius.circular(18),
				child: Image.memory(photoBytes!, fit: BoxFit.cover),
			);
		} else {
			child = Center(
				child: Text(
					initial,
					style: theme.textTheme.titleLarge?.copyWith(
						fontWeight: FontWeight.w900,
						color: theme.colorScheme.primary,
					),
				),
			);
		}

		return Container(
			width: 56,
			height: 56,
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(18),
				color: theme.colorScheme.primary.withAlpha(10),
				border: Border.all(color: outline),
			),
			clipBehavior: Clip.antiAlias,
			child: child,
		);
	}
}

class _TypeChip extends StatelessWidget {
	const _TypeChip({required this.type});

	final TripPlanSubjectType type;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final bg = theme.colorScheme.primary.withAlpha(16);
		final fg = theme.colorScheme.primary;

		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
			decoration: BoxDecoration(
				color: bg,
				borderRadius: BorderRadius.circular(999),
				border: Border.all(color: fg.withAlpha(76)),
			),
			child: Text(
				type.label,
				style: theme.textTheme.bodySmall?.copyWith(
					fontWeight: FontWeight.w900,
					letterSpacing: 0.15,
					color: fg,
				),
			),
		);
	}
}

class _TextPill extends StatelessWidget {
	const _TextPill({required this.label});

	final String label;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);
		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
			decoration: BoxDecoration(
				color: theme.colorScheme.surfaceContainerHighest,
				borderRadius: BorderRadius.circular(999),
				border: Border.all(color: outline),
			),
			child: Text(
				label,
				maxLines: 1,
				overflow: TextOverflow.ellipsis,
				style: theme.textTheme.bodySmall?.copyWith(
					fontWeight: FontWeight.w900,
					letterSpacing: 0.15,
					color: theme.colorScheme.onSurface.withAlpha(190),
				),
			),
		);
	}
}
