
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/team_management.dart';
import '../providers/team_management_provider.dart';

class TeamManagementNotifier extends AsyncNotifier<List<TeamManagement>> {
	@override
	Future<List<TeamManagement>> build() async {
		final repo = ref.read(teamManagementRepositoryProvider);
		return repo.list();
	}

	Future<void> refreshList() async {
		state = const AsyncLoading();
		final repo = ref.read(teamManagementRepositoryProvider);
		state = AsyncData(await repo.list());
	}

	Future<void> upsertTeam(TeamManagement team) async {
		final repo = ref.read(teamManagementRepositoryProvider);
		await repo.upsert(team);
		await refreshList();
	}

	Future<void> deleteTeam(String teamId) async {
		final repo = ref.read(teamManagementRepositoryProvider);
		await repo.delete(teamId);
		await refreshList();
	}

	Future<void> setLeader({required String teamId, required String memberId}) async {
		final repo = ref.read(teamManagementRepositoryProvider);
		await repo.setLeader(teamId: teamId, memberId: memberId);
		await refreshList();
	}

	Future<void> removeMember({required String teamId, required String memberId}) async {
		final repo = ref.read(teamManagementRepositoryProvider);
		await repo.removeMember(teamId: teamId, memberId: memberId);
		await refreshList();
	}

	Future<void> sendAdminTextMessage({required String teamId, required String text}) async {
		final trimmed = text.trim();
		if (trimmed.isEmpty) return;
		final repo = ref.read(teamManagementRepositoryProvider);
		final message = TeamChatMessage(
			id: 'msg_${DateTime.now().microsecondsSinceEpoch}',
			teamId: teamId,
			sentAt: DateTime.now(),
			senderType: TeamMessageSenderType.admin,
			senderName: 'Admin',
			text: trimmed,
		);
		await repo.sendMessage(teamId: teamId, message: message);
		await refreshList();
	}

	Future<void> sendAdminAttachmentMessage({
		required String teamId,
		required TeamMessageAttachment attachment,
		String? text,
	}) async {
		final repo = ref.read(teamManagementRepositoryProvider);
		final message = TeamChatMessage(
			id: 'msg_${DateTime.now().microsecondsSinceEpoch}',
			teamId: teamId,
			sentAt: DateTime.now(),
			senderType: TeamMessageSenderType.admin,
			senderName: 'Admin',
			text: (text == null || text.trim().isEmpty) ? null : text.trim(),
			attachment: attachment,
		);
		await repo.sendMessage(teamId: teamId, message: message);
		await refreshList();
	}
}

final teamManagementNotifierProvider =
		AsyncNotifierProvider<TeamManagementNotifier, List<TeamManagement>>(
			TeamManagementNotifier.new,
		);

