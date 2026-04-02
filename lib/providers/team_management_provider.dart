
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/team_management.dart';

abstract class TeamManagementRepository {
	Future<List<TeamManagement>> list();
	Future<TeamManagement?> getById(String id);
	Future<void> upsert(TeamManagement team);
	Future<void> delete(String id);

	Future<void> setLeader({required String teamId, required String memberId});
	Future<void> removeMember({required String teamId, required String memberId});

	Future<void> sendMessage({required String teamId, required TeamChatMessage message});
}

class InMemoryTeamManagementRepository implements TeamManagementRepository {
	InMemoryTeamManagementRepository();

	final List<TeamManagement> _teams = List<TeamManagement>.of(
		<TeamManagement>[
			TeamManagement(
				id: 'team_1',
				name: 'North Zone Field Team',
				description:
						'Covers the North Zone. Weekly objectives include doctor coverage, chemist audit, and new launch execution.',
				photoBytes: null,
				members: <TeamMember>[
					TeamMember(id: 'mr_1', name: 'Aarav Sharma', role: TeamMemberRole.mr, isLeader: true),
					TeamMember(id: 'asm_1', name: 'Neha Verma', role: TeamMemberRole.asm),
					TeamMember(id: 'mr_2', name: 'Ishita Singh', role: TeamMemberRole.mr),
				],
				messages: <TeamChatMessage>[
					TeamChatMessage(
						id: 'm_1',
						teamId: 'team_1',
						sentAt: DateTime.now().subtract(const Duration(minutes: 34)),
						senderType: TeamMessageSenderType.asm,
						senderName: 'Neha (ASM)',
						text: 'Please share today\'s DCR summary by 6 PM.',
					),
					TeamChatMessage(
						id: 'm_2',
						teamId: 'team_1',
						sentAt: DateTime.now().subtract(const Duration(minutes: 22)),
						senderType: TeamMessageSenderType.mr,
						senderName: 'Aarav (MR)',
						text: 'Noted. I will share by 5:30 PM.',
					),
				],
			),
			TeamManagement(
				id: 'team_2',
				name: 'Launch Execution Squad',
				description:
						'Focused on new launch execution, visual merchandising, and distributor alignment across key territories.',
				photoBytes: null,
				members: <TeamMember>[
					TeamMember(id: 'asm_2', name: 'Rohan Gupta', role: TeamMemberRole.asm, isLeader: true),
					TeamMember(id: 'mr_3', name: 'Meera Patel', role: TeamMemberRole.mr),
				],
				messages: <TeamChatMessage>[
					TeamChatMessage(
						id: 'm_3',
						teamId: 'team_2',
						sentAt: DateTime.now().subtract(const Duration(minutes: 18)),
						senderType: TeamMessageSenderType.mr,
						senderName: 'Meera (MR)',
						text: 'Banner placement done at 4 clinics. Photos attached later.',
					),
				],
			),
		],
		growable: true,
	);

	@override
	Future<List<TeamManagement>> list() async {
		await Future<void>.delayed(const Duration(milliseconds: 220));
		return List<TeamManagement>.unmodifiable(_teams);
	}

	@override
	Future<TeamManagement?> getById(String id) async {
		await Future<void>.delayed(const Duration(milliseconds: 120));
		final index = _teams.indexWhere((t) => t.id == id);
		if (index < 0) return null;
		return _teams[index];
	}

	@override
	Future<void> upsert(TeamManagement team) async {
		await Future<void>.delayed(const Duration(milliseconds: 180));
		final index = _teams.indexWhere((t) => t.id == team.id);
		if (index >= 0) {
			_teams[index] = team;
		} else {
			_teams.insert(0, team);
		}
	}

	@override
	Future<void> delete(String id) async {
		await Future<void>.delayed(const Duration(milliseconds: 150));
		_teams.removeWhere((t) => t.id == id);
	}

	@override
	Future<void> setLeader({required String teamId, required String memberId}) async {
		await Future<void>.delayed(const Duration(milliseconds: 160));
		final teamIndex = _teams.indexWhere((t) => t.id == teamId);
		if (teamIndex < 0) return;

		final team = _teams[teamIndex];
		final updatedMembers = <TeamMember>[
			for (final m in team.members)
				if (m.id == memberId) m.copyWith(isLeader: true) else m.copyWith(isLeader: false),
		];

		_teams[teamIndex] = team.copyWith(members: updatedMembers);
	}

	@override
	Future<void> removeMember({required String teamId, required String memberId}) async {
		await Future<void>.delayed(const Duration(milliseconds: 160));
		final teamIndex = _teams.indexWhere((t) => t.id == teamId);
		if (teamIndex < 0) return;
		final team = _teams[teamIndex];

		final updatedMembers = <TeamMember>[...team.members]..removeWhere((m) => m.id == memberId);
		_teams[teamIndex] = team.copyWith(members: updatedMembers);
	}

	@override
	Future<void> sendMessage({required String teamId, required TeamChatMessage message}) async {
		await Future<void>.delayed(const Duration(milliseconds: 120));
		final teamIndex = _teams.indexWhere((t) => t.id == teamId);
		if (teamIndex < 0) return;
		final team = _teams[teamIndex];
		final updatedMessages = <TeamChatMessage>[...team.messages, message];
		_teams[teamIndex] = team.copyWith(messages: updatedMessages);
	}
}

final teamManagementRepositoryProvider = Provider<TeamManagementRepository>((ref) {
	return InMemoryTeamManagementRepository();
});

