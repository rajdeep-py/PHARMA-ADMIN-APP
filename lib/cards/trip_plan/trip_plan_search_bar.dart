import 'package:flutter/material.dart';

import 'package:iconsax_flutter/iconsax_flutter.dart';

class TripPlanSearchBar extends StatelessWidget {
	const TripPlanSearchBar({
		super.key,
		required this.onQueryChanged,
	});

	final ValueChanged<String> onQueryChanged;

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
				padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
				child: Row(
					children: [
						Container(
							width: 40,
							height: 40,
							decoration: BoxDecoration(
								borderRadius: BorderRadius.circular(16),
								color: theme.colorScheme.primary.withAlpha(12),
								border: Border.all(color: outline),
							),
							child: Icon(
								Iconsax.search_normal_1,
								color: theme.colorScheme.primary,
								size: 20,
							),
						),
						const SizedBox(width: 12),
						Expanded(
							child: TextField(
								onChanged: onQueryChanged,
								style: theme.textTheme.bodyMedium?.copyWith(
									fontWeight: FontWeight.w700,
								),
								decoration: const InputDecoration(
									isDense: true,
									hintText: 'Search MR/ASM by name, phone, or HQ',
									border: InputBorder.none,
									focusedBorder: InputBorder.none,
									enabledBorder: InputBorder.none,
									fillColor: Colors.transparent,
									filled: false,
								),
							),
						),
					],
				),
			),
		);
	}
}
