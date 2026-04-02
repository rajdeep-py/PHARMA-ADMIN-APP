import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/announcement.dart';

abstract class AnnouncementRepository {
	Future<List<Announcement>> list();
	Future<void> upsert(Announcement a);
	Future<void> delete(String id);
}

class InMemoryAnnouncementRepository implements AnnouncementRepository {
	InMemoryAnnouncementRepository();

	final List<Announcement> _items = List<Announcement>.of(
		<Announcement>[
			Announcement(
				id: 'an_1',
				headline: 'New Launch Training',
				description:
						'All ASMs and MRs must attend the launch training on Friday at 11:00 AM.',
				createdAt: DateTime.now().subtract(const Duration(days: 3)),
				updatedAt: DateTime.now().subtract(const Duration(days: 3)),
			),
			Announcement(
				id: 'an_2',
				headline: 'Monthly Review Meeting',
				description:
						'Monthly review meeting scheduled for next Monday. Please keep your DCR and targets ready.',
				createdAt: DateTime.now().subtract(const Duration(days: 10)),
				updatedAt: DateTime.now().subtract(const Duration(days: 7)),
			),
		],
		growable: true,
	);

	@override
	Future<List<Announcement>> list() async {
		await Future<void>.delayed(const Duration(milliseconds: 220));
		final items = [..._items]
			..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
		return List<Announcement>.unmodifiable(items);
	}

	@override
	Future<void> upsert(Announcement a) async {
		await Future<void>.delayed(const Duration(milliseconds: 180));
		final index = _items.indexWhere((e) => e.id == a.id);
		if (index >= 0) {
			_items[index] = a;
		} else {
			_items.insert(0, a);
		}
	}

	@override
	Future<void> delete(String id) async {
		await Future<void>.delayed(const Duration(milliseconds: 150));
		_items.removeWhere((e) => e.id == id);
	}
}

final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
	return InMemoryAnnouncementRepository();
});

