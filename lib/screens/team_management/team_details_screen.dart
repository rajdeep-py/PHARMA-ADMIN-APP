
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/team_management/team_description_card.dart';
import '../../cards/team_management/team_header_card.dart';
import '../../cards/team_management/team_memebers_card.dart';
import '../../notifiers/team_management_notifier.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class TeamDetailsScreen extends ConsumerWidget {
	const TeamDetailsScreen({super.key, required this.teamId});

	final String teamId;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final theme = Theme.of(context);
		final padding = AppLayout.pagePadding(context);
		final teamsAsync = ref.watch(teamManagementNotifierProvider);

		final team = teamsAsync.maybeWhen(
			data: (items) => items.where((t) => t.id == teamId).firstOrNull,
			orElse: () => null,
		);

		return Scaffold(
			appBar: AppAppBar(
				showLogo: false,
				showBackIfPossible: true,
				showMenuIfNoBack: false,
				title: team?.name ?? 'Team Details',
				subtitle: 'Manage members and team info',
			),
			body: SafeArea(
				child: SingleChildScrollView(
					padding: padding,
					child: Align(
						alignment: Alignment.topCenter,
						child: ConstrainedBox(
							constraints: const BoxConstraints(maxWidth: 1120),
							child: teamsAsync.when(
								data: (_) {
									if (team == null) {
										return _ErrorCard(theme: theme, message: 'Team not found.');
									}

									return Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: [
											TeamHeaderCard(
												photoBytes: team.photoBytes,
												teamName: team.name,
												memberCount: team.memberCount,
											),
											const SizedBox(height: 14),
											TeamDescriptionCard(description: team.description),
											const SizedBox(height: 14),
											TeamMemebersCard(
												members: team.members,
												onRemoveMember: (memberId) => ref
														.read(teamManagementNotifierProvider.notifier)
														.removeMember(teamId: team.id, memberId: memberId),
												onMakeLeader: (memberId) => ref
														.read(teamManagementNotifierProvider.notifier)
														.setLeader(teamId: team.id, memberId: memberId),
											),
											const SizedBox(height: 80),
										],
									);
								},
								loading: () => const Center(
									child: Padding(
										padding: EdgeInsets.all(24),
										child: CircularProgressIndicator(),
									),
								),
								error: (e, _) =>
										_ErrorCard(theme: theme, message: 'Failed to load team.'),
							),
						),
					),
				),
			),
		);
	}
}

class _ErrorCard extends StatelessWidget {
	const _ErrorCard({required this.theme, required this.message});

	final ThemeData theme;
	final String message;

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

extension FirstOrNullX<T> on Iterable<T> {
	T? get firstOrNull => isEmpty ? null : first;
}

