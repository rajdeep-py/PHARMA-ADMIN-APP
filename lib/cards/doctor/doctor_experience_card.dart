import 'package:flutter/material.dart';

class DoctorExperienceCard extends StatelessWidget {
	const DoctorExperienceCard({
		super.key,
		required this.degrees,
		required this.experience,
	});

	final List<String> degrees;
	final List<String> experience;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		final cleanDegrees = degrees.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
		final cleanExperience =
			experience.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

		Widget bullet(String text) {
			return Row(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Container(
						width: 8,
						height: 8,
						margin: const EdgeInsets.only(top: 6),
						decoration: BoxDecoration(
							shape: BoxShape.circle,
							color: theme.colorScheme.primary,
						),
					),
					const SizedBox(width: 10),
					Expanded(
						child: Text(
							text,
							style: theme.textTheme.bodyMedium?.copyWith(
								fontWeight: FontWeight.w700,
								color: theme.colorScheme.onSurface.withAlpha(191),
								height: 1.3,
							),
						),
					),
				],
			);
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
				padding: const EdgeInsets.all(18),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Row(
							children: [
								Icon(Icons.work_rounded, color: theme.colorScheme.primary),
								const SizedBox(width: 10),
								Text(
									'Experience',
									style: theme.textTheme.titleMedium?.copyWith(
										fontWeight: FontWeight.w900,
										letterSpacing: -0.2,
									),
								),
							],
						),
						const SizedBox(height: 12),
						if (cleanExperience.isEmpty)
							Text(
								'-',
								style: theme.textTheme.bodyMedium?.copyWith(
									fontWeight: FontWeight.w700,
									color: theme.colorScheme.onSurface.withAlpha(166),
								),
							)
						else
							Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									for (final exp in cleanExperience) ...[
										bullet(exp),
										const SizedBox(height: 8),
									],
								],
							),
						if (cleanDegrees.isNotEmpty) ...[
							const SizedBox(height: 8),
							Divider(color: theme.colorScheme.outline.withAlpha(102)),
							const SizedBox(height: 8),
							Text(
								'Degrees',
								style: theme.textTheme.bodySmall?.copyWith(
									color: theme.colorScheme.onSurface.withAlpha(166),
									fontWeight: FontWeight.w800,
								),
							),
							const SizedBox(height: 6),
							Text(
								cleanDegrees.join(', '),
								style: theme.textTheme.bodyMedium?.copyWith(
									fontWeight: FontWeight.w800,
								),
							),
						],
					],
				),
			),
		);
	}
}
