
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/trip_plan.dart';

abstract class TripPlanRepository {
	Future<List<TripPlan>> list();

	Future<TripPlan?> findBySubject({
		required TripPlanSubjectType subjectType,
		required String subjectId,
	});

	Future<void> upsert(TripPlan plan);

	Future<void> delete(String id);
}

class InMemoryTripPlanRepository implements TripPlanRepository {
	InMemoryTripPlanRepository();

	final List<TripPlan> _items = List<TripPlan>.of([
		TripPlan(
			id: 'trip_mr_1',
			subjectType: TripPlanSubjectType.mr,
			subjectId: 'mr_1',
			days: [
				TripPlanDayPlan(
					day: tripPlanDayOnly(DateTime.now().subtract(const Duration(days: 1))),
					items: const [
						'Dr. Ananya Bose - Salt Lake (follow-up)',
						'Chemist visit - Park Street',
						'Distributor coordination - Apex Distributors',
					],
				),
				TripPlanDayPlan(
					day: tripPlanDayOnly(DateTime.now().add(const Duration(days: 2))),
					items: const [
						'Dr. Kunal Roy - OPD hours (morning)',
						'Clinic meeting - territory review',
					],
				),
			],
		),
		TripPlan(
			id: 'trip_asm_1',
			subjectType: TripPlanSubjectType.asm,
			subjectId: 'asm_1',
			days: [
				TripPlanDayPlan(
					day: tripPlanDayOnly(DateTime.now().subtract(const Duration(days: 3))),
					items: const [
						'MR ride-along - Shivaji Nagar',
						'Area review meeting - Pune HQ',
					],
				),
			],
		),
	], growable: true);

	@override
	Future<List<TripPlan>> list() async {
		await Future<void>.delayed(const Duration(milliseconds: 220));
		return List<TripPlan>.unmodifiable(_items);
	}

	@override
	Future<TripPlan?> findBySubject({
		required TripPlanSubjectType subjectType,
		required String subjectId,
	}) async {
		await Future<void>.delayed(const Duration(milliseconds: 120));
		try {
			return _items.firstWhere(
				(e) => e.subjectType == subjectType && e.subjectId == subjectId,
			);
		} catch (_) {
			return null;
		}
	}

	@override
	Future<void> upsert(TripPlan plan) async {
		await Future<void>.delayed(const Duration(milliseconds: 180));
		final index = _items.indexWhere((e) => e.id == plan.id);
		if (index >= 0) {
			_items[index] = plan;
		} else {
			_items.insert(0, plan);
		}
	}

	@override
	Future<void> delete(String id) async {
		await Future<void>.delayed(const Duration(milliseconds: 150));
		_items.removeWhere((e) => e.id == id);
	}
}

final tripPlanRepositoryProvider = Provider<TripPlanRepository>((ref) {
	return InMemoryTripPlanRepository();
});
