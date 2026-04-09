import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../models/doctor.dart';

class DoctorChamberCard extends StatelessWidget {
	const DoctorChamberCard({
		super.key,
		required this.chambers,
	});

	final List<DoctorChamber> chambers;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);
		final items = chambers
				.map((c) => DoctorChamber(
					name: c.name.trim(),
					phoneNumber: c.phoneNumber.trim(),
					address: c.address.trim(),
				))
				.where((c) => c.name.isNotEmpty || c.phoneNumber.isNotEmpty || c.address.isNotEmpty)
				.toList(growable: false);

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
								Icon(Icons.location_city_rounded, color: theme.colorScheme.primary),
								const SizedBox(width: 10),
								Text(
									'Chambers',
									style: theme.textTheme.titleMedium?.copyWith(
										fontWeight: FontWeight.w900,
										letterSpacing: -0.2,
									),
								),
							],
						),
						const SizedBox(height: 12),
						if (items.isEmpty)
							Text(
								'-',
								style: theme.textTheme.bodyMedium?.copyWith(
									fontWeight: FontWeight.w700,
									color: theme.colorScheme.onSurface.withAlpha(166),
								),
							)
						else
							Column(
								crossAxisAlignment: CrossAxisAlignment.stretch,
								children: [
									for (final chamber in items) ...[
										_ChamberTile(chamber: chamber),
										const SizedBox(height: 10),
									],
								],
							),
					],
				),
			),
		);
	}
}

class _ChamberTile extends StatelessWidget {
	const _ChamberTile({required this.chamber});

	final DoctorChamber chamber;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(90);

		final name = chamber.name.trim().isEmpty ? 'Chamber' : chamber.name.trim();
		final phone = chamber.phoneNumber.trim();
		final address = chamber.address.trim();

		return Container(
			padding: const EdgeInsets.all(14),
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(20),
				border: Border.all(color: outline),
				color: theme.colorScheme.surface,
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(
						name,
						style: theme.textTheme.titleMedium?.copyWith(
							fontWeight: FontWeight.w900,
							letterSpacing: -0.2,
						),
					),
					if (phone.isNotEmpty || address.isNotEmpty) ...[
						const SizedBox(height: 8),
						if (phone.isNotEmpty)
							_ActionRow(
								icon: Icons.phone_rounded,
								label: 'Phone',
								value: phone,
								onTap: () => _dial(phone),
							),
						if (phone.isNotEmpty && address.isNotEmpty) const SizedBox(height: 8),
						if (address.isNotEmpty)
							_ActionRow(
								icon: Icons.location_on_rounded,
								label: 'Address',
								value: address,
								onTap: () => _openMaps(address),
							),
					],
				],
			),
		);
	}

	Future<void> _openMaps(String address) async {
		final uri = Uri.parse(
			'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
		);
		await launchUrl(uri, mode: LaunchMode.externalApplication);
	}

	Future<void> _dial(String phoneNumber) async {
		final uri = Uri(scheme: 'tel', path: phoneNumber);
		await launchUrl(uri, mode: LaunchMode.externalApplication);
	}
}

class _ActionRow extends StatelessWidget {
	const _ActionRow({
		required this.icon,
		required this.label,
		required this.value,
		required this.onTap,
	});

	final IconData icon;
	final String label;
	final String value;
	final VoidCallback onTap;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(90);

		return InkWell(
			onTap: onTap,
			borderRadius: BorderRadius.circular(18),
			child: Container(
				padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
				decoration: BoxDecoration(
					borderRadius: BorderRadius.circular(18),
					border: Border.all(color: outline),
					color: theme.colorScheme.surface,
				),
				child: Row(
					children: [
						Container(
							width: 36,
							height: 36,
							decoration: BoxDecoration(
								borderRadius: BorderRadius.circular(14),
								color: theme.colorScheme.primary.withAlpha(18),
								border: Border.all(
									color: theme.colorScheme.primary.withAlpha(70),
								),
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
										style: theme.textTheme.bodySmall?.copyWith(
											color: theme.colorScheme.onSurface.withAlpha(166),
											fontWeight: FontWeight.w800,
										),
									),
									const SizedBox(height: 2),
									Text(
										value,
										style: theme.textTheme.bodyMedium?.copyWith(
											fontWeight: FontWeight.w800,
										),
									),
								],
							),
						),
						const SizedBox(width: 10),
						Icon(
							Icons.open_in_new_rounded,
							size: 18,
							color: theme.colorScheme.onSurface.withAlpha(166),
						),
					],
				),
			),
		);
	}
}
