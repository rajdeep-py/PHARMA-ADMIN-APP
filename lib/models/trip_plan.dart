
enum TripPlanSubjectType { mr, asm }

extension TripPlanSubjectTypeX on TripPlanSubjectType {
	String get label {
		switch (this) {
			case TripPlanSubjectType.mr:
				return 'MR';
			case TripPlanSubjectType.asm:
				return 'ASM';
		}
	}
}

class TripPlanDayPlan {
	const TripPlanDayPlan({required this.day, required this.items});

	/// Day-only date (time should be 00:00).
	final DateTime day;

	/// Simple per-line plan items (e.g. "Doctor visit - Salt Lake").
	final List<String> items;

	TripPlanDayPlan copyWith({DateTime? day, List<String>? items}) {
		return TripPlanDayPlan(
			day: day ?? this.day,
			items: items ?? this.items,
		);
	}
}

class TripPlan {
	const TripPlan({
		required this.id,
		required this.subjectType,
		required this.subjectId,
		required this.days,
	});

	final String id;

	final TripPlanSubjectType subjectType;
	final String subjectId;

	final List<TripPlanDayPlan> days;

	TripPlan copyWith({
		String? id,
		TripPlanSubjectType? subjectType,
		String? subjectId,
		List<TripPlanDayPlan>? days,
	}) {
		return TripPlan(
			id: id ?? this.id,
			subjectType: subjectType ?? this.subjectType,
			subjectId: subjectId ?? this.subjectId,
			days: days ?? this.days,
		);
	}
}

DateTime tripPlanDayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
