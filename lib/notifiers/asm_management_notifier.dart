import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mr_management.dart';

import '../providers/asm_management_provider.dart';

class AsmManagementNotifier extends AsyncNotifier<List<MrManagement>> {
	@override
	Future<List<MrManagement>> build() async {
		final repo = ref.read(asmManagementRepositoryProvider);
		return repo.list();
	}

	Future<void> refreshList() async {
		state = const AsyncLoading();
		final repo = ref.read(asmManagementRepositoryProvider);
		state = AsyncData(await repo.list());
	}

	Future<void> upsert(MrManagement asm) async {
		final repo = ref.read(asmManagementRepositoryProvider);
		await repo.upsert(asm);
		await refreshList();
	}

	Future<void> delete(String id) async {
		final repo = ref.read(asmManagementRepositoryProvider);
		await repo.delete(id);
		await refreshList();
	}
}

final asmManagementNotifierProvider =
		AsyncNotifierProvider<AsmManagementNotifier, List<MrManagement>>(
	AsmManagementNotifier.new,
);

