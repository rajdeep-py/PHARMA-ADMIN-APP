import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cards/distributor/distributor_card.dart';
import '../../cards/distributor/distributor_search_filter_bar.dart';
import '../../notifiers/asm_management_notifier.dart';
import '../../notifiers/distributor_notifier.dart';
import '../../notifiers/mr_management_notifier.dart';
import '../../models/distributor.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';

class DistributorScreen extends ConsumerStatefulWidget {
	const DistributorScreen({super.key});

	@override
	ConsumerState<DistributorScreen> createState() => _DistributorScreenState();
}

class _DistributorScreenState extends ConsumerState<DistributorScreen> {
	String _query = '';
	String? _selectedMrId;
	String? _selectedAsmId;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final padding = AppLayout.pagePadding(context);
		final listAsync = ref.watch(distributorNotifierProvider);
		final mrAsync = ref.watch(mrManagementNotifierProvider);
		final asmAsync = ref.watch(asmManagementNotifierProvider);

		final mrOptions = mrAsync.maybeWhen(
			data: (items) => items
					.map((m) => (id: m.id, label: m.name))
					.toList(growable: false),
			orElse: () => const <({String id, String label})>[],
		);
		final asmOptions = asmAsync.maybeWhen(
			data: (items) => items
					.map((a) => (id: a.id, label: a.name))
					.toList(growable: false),
			orElse: () => const <({String id, String label})>[],
		);

		return Scaffold(
			appBar: const AppAppBar(
				showLogo: false,
				showBackIfPossible: false,
				title: 'Distributor Management',
				subtitle: 'Search and view distributor network',
				showMenuIfNoBack: true,
			),
			drawer: SideNavBarDrawer(
				companyName: 'Naiyo24',
				tagline: 'Admin console',
				selectedIndex: SideNavBarDrawer.destinations.indexOf(
					SideNavDestination.distributorManagement,
				),
			),
			floatingActionButton: FloatingActionButton.extended(
				onPressed: () => context.goNamed(AppRoutes.createDistributor),
				icon: const Icon(Icons.add_rounded),
				label: const Text('Add distributor'),
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
									final q = _query.trim().toLowerCase();
									final filtered = items
											.where((d) {
												final matchesQuery = q.isEmpty
														? true
														: d.name.toLowerCase().contains(q) ||
																d.address.toLowerCase().contains(q);
											final matchesMr = _selectedMrId == null
												? true
												: (d.addedByType == DistributorAddedByType.mr &&
													d.addedById == _selectedMrId);
											final matchesAsm = _selectedAsmId == null
												? true
												: (d.addedByType == DistributorAddedByType.asm &&
													d.addedById == _selectedAsmId);
												return matchesQuery && matchesMr && matchesAsm;
											})
											.toList(growable: false);

									return Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: [
											DistributorSearchFilterBar(
												onQueryChanged: (v) => setState(() => _query = v),
												mrOptions: mrOptions,
												asmOptions: asmOptions,
												selectedMrId: _selectedMrId,
												selectedAsmId: _selectedAsmId,
												onMrChanged: (v) => setState(() {
													_selectedMrId = v;
													if (v != null) _selectedAsmId = null;
												}),
												onAsmChanged: (v) => setState(() {
													_selectedAsmId = v;
													if (v != null) _selectedMrId = null;
												}),
											),
											const SizedBox(height: 14),
											if (items.isEmpty)
												_EmptyCard(theme: theme)
											else if (filtered.isEmpty)
												_EmptyCard(
													theme: theme,
													message:
															'No distributors found. Try a different search or filter.',
												)
											else
												Column(
													crossAxisAlignment: CrossAxisAlignment.stretch,
													children: [
														for (final d in filtered) ...[
															DistributorCard(
																photoPath: d.photoPath,
																photoBytes: d.photoBytes,
																distributorName: d.name,
																distributorAddress: d.address,
																onTap: () => context.goNamed(
																	AppRoutes.distributorDetails,
																	pathParameters: {'distributorId': d.id},
																),
															),
															const SizedBox(height: 12),
														],
													],
												),
											const SizedBox(height: 92),
										],
									);
								},
								loading: () => _LoadingCard(theme: theme),
								error: (e, _) => const _ErrorCard(
									message: 'Failed to load distributor list.',
								),
							),
						),
					),
				),
			),
		);
	}
}

class _EmptyCard extends StatelessWidget {
	const _EmptyCard({required this.theme, this.message});

	final ThemeData theme;
	final String? message;

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
			child: Padding(
				padding: const EdgeInsets.all(18),
				child: Text(
					message ?? 'No distributors found.',
					style: theme.textTheme.bodyMedium?.copyWith(
						fontWeight: FontWeight.w800,
						color: theme.colorScheme.onSurface.withAlpha(180),
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
						Text('Loading distributors...'),
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

