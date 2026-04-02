
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../models/team_management.dart';

class TeamMemebersCard extends StatelessWidget {
	const TeamMemebersCard({
		super.key,
		required this.members,
		required this.onRemoveMember,
		required this.onMakeLeader,
	});

	final List<TeamMember> members;
	final ValueChanged<String> onRemoveMember;
	final ValueChanged<String> onMakeLeader;

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
				padding: const EdgeInsets.all(18),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Row(
							children: [
								Icon(
									Icons.group_rounded,
									color: theme.colorScheme.primary,
								),
								const SizedBox(width: 10),
								Text(
									'Team members',
									style: theme.textTheme.titleSmall?.copyWith(
										fontWeight: FontWeight.w900,
									),
								),
							],
						),
						const SizedBox(height: 10),
						if (members.isEmpty)
							Text(
								'No members in this team yet.',
								style: theme.textTheme.bodyMedium?.copyWith(
									color: theme.colorScheme.onSurface.withAlpha(170),
									fontWeight: FontWeight.w700,
								),
							)
						else
							Column(
								children: [
									for (final member in members) ...[
										_MemberRow(
											member: member,
											onRemove: () => onRemoveMember(member.id),
											onMakeLeader: member.isLeader
													? null
													: () => onMakeLeader(member.id),
										),
										if (member != members.last)
											Divider(color: outline.withAlpha(140), height: 18),
									],
								],
							),
					],
				),
			),
		);
	}
}

class _MemberRow extends StatelessWidget {
	const _MemberRow({
		required this.member,
		required this.onRemove,
		required this.onMakeLeader,
	});

	final TeamMember member;
	final VoidCallback onRemove;
	final VoidCallback? onMakeLeader;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		theme.colorScheme.outline.withAlpha(102);

		return Row(
			children: [
				_Avatar(photoBytes: member.photoBytes),
				const SizedBox(width: 12),
				Expanded(
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Row(
								children: [
									Expanded(
										child: Text(
											member.name,
											maxLines: 1,
											overflow: TextOverflow.ellipsis,
											style: theme.textTheme.titleSmall?.copyWith(
												fontWeight: FontWeight.w900,
											),
										),
									),
									const SizedBox(width: 8),
									if (member.isLeader)
										Container(
											padding: const EdgeInsets.symmetric(
												horizontal: 10,
												vertical: 6,
											),
											decoration: BoxDecoration(
												color: theme.colorScheme.primary.withAlpha(14),
												borderRadius: BorderRadius.circular(999),
												border: Border.all(
													color: theme.colorScheme.primary.withAlpha(80),
												),
											),
											child: Text(
												'Leader',
												style: theme.textTheme.labelMedium?.copyWith(
													color: theme.colorScheme.primary,
													fontWeight: FontWeight.w900,
												),
											),
										),
								],
							),
							const SizedBox(height: 4),
							Text(
								member.roleLabel,
								style: theme.textTheme.bodySmall?.copyWith(
									color: theme.colorScheme.onSurface.withAlpha(166),
									fontWeight: FontWeight.w800,
								),
							),
						],
					),
				),
				const SizedBox(width: 10),
				IconButton(
					tooltip: 'Remove member',
					onPressed: onRemove,
					icon: Icon(
						Icons.person_remove_alt_1_rounded,
						color: theme.colorScheme.error,
					),
				),
				IconButton(
					tooltip: member.isLeader ? 'Team leader' : 'Make leader',
					onPressed: onMakeLeader,
					icon: Icon(
						Icons.star_rounded,
						color: member.isLeader
								? theme.colorScheme.primary
								: theme.colorScheme.onSurface.withAlpha(160),
					),
				),
			],
		);
	}
}

class _Avatar extends StatelessWidget {
	const _Avatar({required this.photoBytes});

	final Uint8List? photoBytes;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		final image = (photoBytes == null)
				? null
				: ClipRRect(
						borderRadius: BorderRadius.circular(16),
						child: Image.memory(
							photoBytes!,
							width: 44,
							height: 44,
							fit: BoxFit.cover,
						),
					);

		return Container(
			width: 48,
			height: 48,
			padding: const EdgeInsets.all(2),
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(18),
				border: Border.all(color: outline),
			),
			child: (image != null)
					? image
					: Container(
							decoration: BoxDecoration(
								borderRadius: BorderRadius.circular(16),
								color: theme.colorScheme.primary.withAlpha(12),
							),
							child: Icon(
								Icons.person_rounded,
								color: theme.colorScheme.primary,
								size: 22,
							),
						),
		);
	}
}

