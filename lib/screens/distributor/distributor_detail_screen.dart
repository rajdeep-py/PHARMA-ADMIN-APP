import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cards/distributor/distributor_contact_card.dart';
import '../../cards/distributor/distributor_description_card.dart';
import '../../cards/distributor/distributor_header_card.dart';
import '../../cards/distributor/distributor_order_info_card.dart';
import '../../models/distributor.dart';
import '../../notifiers/distributor_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class DistributorDetailScreen extends ConsumerWidget {
	const DistributorDetailScreen({super.key, required this.distributorId});

	final String distributorId;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final theme = Theme.of(context);
		final padding = AppLayout.pagePadding(context);
		final listAsync = ref.watch(distributorNotifierProvider);

		return Scaffold(
			appBar: const AppAppBar(
				showLogo: false,
				title: 'Distributor',
				subtitle: 'Details',
			),
			body: SafeArea(
				child: SingleChildScrollView(
					padding: padding,
					child: Align(
						alignment: Alignment.topCenter,
						child: ConstrainedBox(
							constraints: const BoxConstraints(maxWidth: 1120),
							child: listAsync.when(
								data: (items) {
									Distributor? distributor;
									try {
										distributor = items.firstWhere((d) => d.id == distributorId);
									} catch (_) {
										distributor = null;
									}

									if (distributor == null) {
										return const _ErrorCard(
											message: 'Distributor not found.',
										);
									}

									final d = distributor;

									return Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: [
											DistributorHeaderCard(
												photoPath: d.photoPath,
												photoBytes: d.photoBytes,
												distributorName: d.name,
												addedByLabel: 'Added by ${d.addedByType.label}: ${d.addedByName}',
												onEdit: () => context.goNamed(
													AppRoutes.editDistributor,
													pathParameters: {'distributorId': d.id},
												),
												onDelete: () async {
													await ref
															.read(distributorNotifierProvider.notifier)
															.delete(d.id);
													if (!context.mounted) return;
													context.goNamed(AppRoutes.distributorManagement);
												},
											),
											const SizedBox(height: 12),
											DistributorDescriptionCard(
												description: d.description,
											),
											const SizedBox(height: 12),
											DistributorOrderInfoCard(
												minimumOrderValue: d.minimumOrderValue,
												expectedDeliveryTime: d.expectedDeliveryTime,
												productsAvailable: d.productsAvailable,
											),
											const SizedBox(height: 12),
											DistributorContactCard(
												phoneNumber: d.phoneNumber,
												email: d.email,
												address: d.address,
											),
											const SizedBox(height: 92),
										],
									);
								},
								loading: () => _LoadingCard(theme: theme),
								error: (e, _) => const _ErrorCard(
									message: 'Failed to load distributor details.',
								),
							),
						),
					),
				),
			),
		);
	}
}

class _LoadingCard extends StatelessWidget {
	const _LoadingCard({required this.theme});

	final ThemeData theme;

	@override
	Widget build(BuildContext context) {
		final outline = theme.colorScheme.outline.withAlpha(204);
		return Card(
			elevation: 0,
			surfaceTintColor: Colors.transparent,
			color: theme.colorScheme.surface,
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(24),
				side: BorderSide(color: outline),
			),
			child: const Padding(
				padding: EdgeInsets.all(18),
				child: Row(
					children: [
						SizedBox(
							width: 18,
							height: 18,
							child: CircularProgressIndicator(strokeWidth: 2),
						),
						SizedBox(width: 12),
						Text('Loading details...'),
					],
				),
			),
		);
	}
}

class _ErrorCard extends StatelessWidget {
	const _ErrorCard({required this.message});

	final String message;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(204);
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
				child: Text(
					message,
					style: theme.textTheme.bodyMedium?.copyWith(
						color: theme.colorScheme.error,
						fontWeight: FontWeight.w800,
					),
				),
			),
		);
	}
}

