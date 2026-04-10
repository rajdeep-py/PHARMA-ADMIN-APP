import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/team_management/team_description_card.dart';
import '../../cards/team_management/team_header_card.dart';
import '../../cards/team_management/team_memebers_card.dart';
import '../../models/team_management.dart';
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
                        onAddMember: () async {
                          final result = await showDialog<_AddMemberResult>(
                            context: context,
                            builder: (context) => const _AddMemberDialog(),
                          );
                          if (result == null) return;

                          final member = TeamMember(
                            id: 'member_${DateTime.now().microsecondsSinceEpoch}',
                            name: result.name,
                            role: result.role,
                          );

                          await ref
                              .read(teamManagementNotifierProvider.notifier)
                              .addMember(teamId: team.id, member: member);
                        },
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

class _AddMemberResult {
  const _AddMemberResult({required this.name, required this.role});

  final String name;
  final TeamMemberRole role;
}

class _AddMemberDialog extends StatefulWidget {
  const _AddMemberDialog();

  @override
  State<_AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<_AddMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  TeamMemberRole _role = TeamMemberRole.mr;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add member'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter member name',
                ),
                autofocus: true,
                textInputAction: TextInputAction.next,
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return 'Name is required.';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<TeamMemberRole>(
                initialValue: _role,
                decoration: const InputDecoration(labelText: 'Role'),
                items: const [
                  DropdownMenuItem(value: TeamMemberRole.mr, child: Text('MR')),
                  DropdownMenuItem(
                    value: TeamMemberRole.asm,
                    child: Text('ASM'),
                  ),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _role = v);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final ok = _formKey.currentState?.validate() ?? false;
            if (!ok) return;
            Navigator.of(
              context,
            ).pop(_AddMemberResult(name: _nameCtrl.text.trim(), role: _role));
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

extension FirstOrNullX<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
