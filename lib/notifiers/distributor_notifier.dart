import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/distributor.dart';
import '../providers/distributor_provider.dart';

class DistributorNotifier extends AsyncNotifier<List<Distributor>> {
	@override
	Future<List<Distributor>> build() async {
		final repo = ref.read(distributorRepositoryProvider);
		return repo.list();
	}

	Future<void> refreshList() async {
		state = const AsyncLoading();
		final repo = ref.read(distributorRepositoryProvider);
		state = AsyncData(await repo.list());
	}

	Future<Distributor?> findById(String id) {
		final repo = ref.read(distributorRepositoryProvider);
		return repo.findById(id);
	}

	Future<void> upsert(Distributor distributor) async {
		final repo = ref.read(distributorRepositoryProvider);
		await repo.upsert(distributor);
		await refreshList();
	}

	Future<void> delete(String id) async {
		final repo = ref.read(distributorRepositoryProvider);
		await repo.delete(id);
		await refreshList();
	}
}

final distributorNotifierProvider =
		AsyncNotifierProvider<DistributorNotifier, List<Distributor>>(
			DistributorNotifier.new,
		);

