import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cards/announcement/announcement_card.dart';
import '../../notifiers/announcement_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';

class AnnouncementManagementScreen extends ConsumerWidget {
	const AnnouncementManagementScreen({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final theme = Theme.of(context);
		final padding = AppLayout.pagePadding(context);
		final listAsync = ref.watch(announcementNotifierProvider);

		return Scaffold(
			appBar: const AppAppBar(
				showLogo: false,
				showBackIfPossible: false,
				title: 'Announcement Management',
				subtitle: 'Create, edit, and manage announcements',
				showMenuIfNoBack: true,
			),
			drawer: SideNavBarDrawer(
				companyName: 'Naiyo24',
				tagline: 'Admin console',
				selectedIndex: SideNavBarDrawer.destinations.indexOf(
					SideNavDestination.announcements,
				),
			),
			floatingActionButton: FloatingActionButton.extended(
				onPressed: () => context.goNamed(AppRoutes.createAnnouncement),
				icon: const Icon(Icons.add_rounded),
				label: const Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text('Create'),
						Text('Announcement'),
					],
				),
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
									if (items.isEmpty) {
										return _EmptyCard(theme: theme);
									}

									return Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: [
											for (final a in items) ...[
												AnnouncementCard(
													headline: a.headline,
													description: a.description,
													onEdit: () => context.goNamed(
													AppRoutes.editAnnouncement,
													pathParameters: {'announcementId': a.id},
												),
													onDelete: () => ref
														.read(announcementNotifierProvider.notifier)
														.delete(a.id),
												),
												const SizedBox(height: 12),
											],
											const SizedBox(height: 80),
										],
									);
								},
								loading: () => _LoadingCard(theme: theme),
								error: (e, _) => const _ErrorCard(
									message: 'Failed to load announcements.',
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
	const _EmptyCard({required this.theme});

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
			child: Padding(
				padding: const EdgeInsets.all(18),
				child: Text(
					'No announcements yet. Tap “Create Announcement” to add one.',
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
						Text('Loading announcements...'),
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

