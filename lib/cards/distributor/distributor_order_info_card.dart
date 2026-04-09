import 'package:flutter/material.dart';

class DistributorOrderInfoCard extends StatelessWidget {
	const DistributorOrderInfoCard({
		super.key,
		required this.minimumOrderValue,
		required this.expectedDeliveryTime,
		required this.productsAvailable,
	});

	final double minimumOrderValue;
	final String expectedDeliveryTime;
	final List<String> productsAvailable;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		String normalize(String v) {
			final t = v.trim();
			return t.isEmpty ? '-' : t;
		}

		final products = productsAvailable
				.map((e) => e.trim())
				.where((e) => e.isNotEmpty)
				.toList(growable: false);
		final productsLabel = products.isEmpty ? '-' : products.join(', ');

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
							'Order info',
							style: theme.textTheme.titleMedium?.copyWith(
								fontWeight: FontWeight.w900,
								letterSpacing: -0.2,
							),
						),
						const SizedBox(height: 12),
						_RowItem(
							icon: Icons.currency_rupee_rounded,
							label: 'Minimum order value',
							value: minimumOrderValue <= 0
									? '-'
									: minimumOrderValue.toStringAsFixed(0),
						),
						const SizedBox(height: 10),
						_RowItem(
							icon: Icons.local_shipping_rounded,
							label: 'Expected delivery',
							value: normalize(expectedDeliveryTime),
						),
						const SizedBox(height: 10),
						_RowItem(
							icon: Icons.inventory_2_rounded,
							label: 'Products available',
							value: productsLabel,
						),
					],
				),
			),
		);
	}
}

class _RowItem extends StatelessWidget {
	const _RowItem({
		required this.icon,
		required this.label,
		required this.value,
	});

	final IconData icon;
	final String label;
	final String value;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		return Row(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Container(
					width: 42,
					height: 42,
					decoration: BoxDecoration(
						borderRadius: BorderRadius.circular(16),
						color: theme.colorScheme.primary.withAlpha(14),
						border: Border.all(color: outline),
					),
					child: Icon(icon, color: theme.colorScheme.primary, size: 20),
				),
				const SizedBox(width: 12),
				Expanded(
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text(
								label,
								style: theme.textTheme.labelLarge?.copyWith(
									color: theme.colorScheme.onSurface.withAlpha(166),
									fontWeight: FontWeight.w900,
								),
							),
							const SizedBox(height: 4),
							Text(
								value,
								style: theme.textTheme.bodyMedium?.copyWith(
									fontWeight: FontWeight.w800,
									height: 1.2,
								),
							),
						],
					),
				),
			],
		);
	}
}

