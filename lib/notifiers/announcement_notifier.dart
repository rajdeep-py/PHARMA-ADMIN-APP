import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/announcement.dart';
import '../providers/announcement_provider.dart';

class AnnouncementNotifier extends AsyncNotifier<List<Announcement>> {
	@override
	Future<List<Announcement>> build() async {
		final repo = ref.read(announcementRepositoryProvider);
		return repo.list();
	}

	Future<void> refreshList() async {
		state = const AsyncLoading();
		final repo = ref.read(announcementRepositoryProvider);
		state = AsyncData(await repo.list());
	}

	Future<void> upsert(Announcement a) async {
		final repo = ref.read(announcementRepositoryProvider);
		await repo.upsert(a);
		await refreshList();
	}

	Future<void> delete(String id) async {
		final repo = ref.read(announcementRepositoryProvider);
		await repo.delete(id);
		await refreshList();
	}
}

final announcementNotifierProvider =
		AsyncNotifierProvider<AnnouncementNotifier, List<Announcement>>(
			AnnouncementNotifier.new,
		);

