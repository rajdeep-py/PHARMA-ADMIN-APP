
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/trip_plan.dart';
import '../providers/trip_plan_provider.dart';

class TripPlanNotifier extends AsyncNotifier<List<TripPlan>> {
	@override
	Future<List<TripPlan>> build() async {
		final repo = ref.read(tripPlanRepositoryProvider);
		return repo.list();
	}

	Future<void> refreshList() async {
		state = const AsyncLoading();
		final repo = ref.read(tripPlanRepositoryProvider);
		state = AsyncData(await repo.list());
	}

	TripPlan? findForSubject({
		required TripPlanSubjectType subjectType,
		required String subjectId,
	}) {
		final items = state.asData?.value;
		if (items == null) return null;
		try {
			return items.firstWhere(
				(e) => e.subjectType == subjectType && e.subjectId == subjectId,
			);
		} catch (_) {
			return null;
		}
	}

	Future<void> upsert(TripPlan plan) async {
		final repo = ref.read(tripPlanRepositoryProvider);
		await repo.upsert(plan);
		await refreshList();
	}

	Future<void> delete(String id) async {
		final repo = ref.read(tripPlanRepositoryProvider);
		await repo.delete(id);
		await refreshList();
	}

	Future<void> setDayPlan({
		required TripPlanSubjectType subjectType,
		required String subjectId,
		required DateTime day,
		required List<String> items,
	}) async {
		final normalizedDay = tripPlanDayOnly(day);
		final current = findForSubject(subjectType: subjectType, subjectId: subjectId);

		final nextDays = <TripPlanDayPlan>[];
		if (current != null) {
			for (final d in current.days) {
				if (tripPlanDayOnly(d.day) == normalizedDay) continue;
				nextDays.add(d);
			}
		}
		if (items.isNotEmpty) {
			nextDays.add(TripPlanDayPlan(day: normalizedDay, items: items));
		}
		nextDays.sort((a, b) => a.day.compareTo(b.day));

		final plan = TripPlan(
			id: current?.id ?? 'trip_${subjectType.name}_$subjectId',
			subjectType: subjectType,
			subjectId: subjectId,
			days: List<TripPlanDayPlan>.unmodifiable(nextDays),
		);

		await upsert(plan);
	}
}

final tripPlanNotifierProvider =
		AsyncNotifierProvider<TripPlanNotifier, List<TripPlan>>(TripPlanNotifier.new);
