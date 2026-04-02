
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cards/team_management/team_card.dart';
import '../../cards/team_management/team_search_bar.dart';
import '../../notifiers/team_management_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';

class TeamManagementScreen extends ConsumerStatefulWidget {
	const TeamManagementScreen({super.key});

	@override
	ConsumerState<TeamManagementScreen> createState() =>
			_TeamManagementScreenState();
}

class _TeamManagementScreenState extends ConsumerState<TeamManagementScreen> {
	String _query = '';

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final padding = AppLayout.pagePadding(context);
		final teamsAsync = ref.watch(teamManagementNotifierProvider);

		return Scaffold(
			appBar: const AppAppBar(
				showLogo: false,
				showBackIfPossible: false,
				title: 'Team Management',
				subtitle: 'Create teams and manage team chats',
			),
			drawer: SideNavBarDrawer(
				companyName: 'Naiyo24',
				tagline: 'Admin console',
				selectedIndex: SideNavBarDrawer.destinations.indexOf(
					SideNavDestination.teamManagement,
				),
			),
			floatingActionButton: FloatingActionButton.extended(
				onPressed: () => context.goNamed(AppRoutes.createTeam),
				icon: const Icon(Icons.add_rounded),
				label: const Text('Create a Team'),
			),
			body: SafeArea(
				child: SingleChildScrollView(
					padding: padding,
					child: Align(
						alignment: Alignment.topCenter,
						child: ConstrainedBox(
							constraints: const BoxConstraints(maxWidth: 1120),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.stretch,
								children: [
									TeamSearchBar(
										hintText: 'Search teams by name',
										onChanged: (v) => setState(() => _query = v),
									),
									const SizedBox(height: 14),
									teamsAsync.when(
										data: (items) {
											final q = _query.trim().toLowerCase();
											final filtered = (q.isEmpty)
													? items
													: items
															.where(
																(t) => t.name.toLowerCase().contains(q),
															)
															.toList();

											if (filtered.isEmpty) {
												return _EmptyCard(theme: theme);
											}

											return Column(
												crossAxisAlignment: CrossAxisAlignment.stretch,
												children: [
													for (final team in filtered) ...[
														TeamCard(
															photoBytes: team.photoBytes,
															teamName: team.name,
															teamDescription: team.description,
															onTap: () => context.goNamed(
																AppRoutes.teamChatRoom,
																pathParameters: {'teamId': team.id},
															),
															onEdit: () => context.goNamed(
																AppRoutes.editTeam,
																pathParameters: {'teamId': team.id},
															),
															onDelete: () => ref
																	.read(teamManagementNotifierProvider.notifier)
																	.deleteTeam(team.id),
														),
														const SizedBox(height: 12),
													],
												],
											);
										},
										loading: () => _LoadingCard(theme: theme),
										error: (e, _) => const _ErrorCard(
											message: 'Failed to load teams.',
										),
									),
									const SizedBox(height: 80),
								],
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
						Text('Loading teams...'),
					],
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
			child: const Padding(
				padding: EdgeInsets.all(18),
				child: Text('No teams found.'),
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
						fontWeight: FontWeight.w700,
					),
				),
			),
		);
	}
}

