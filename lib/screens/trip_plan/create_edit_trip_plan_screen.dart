
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/trip_plan/day_plan_card.dart';
import '../../cards/trip_plan/trip_plan_calendar_card.dart';
import '../../models/mr_management.dart';
import '../../models/trip_plan.dart';
import '../../notifiers/asm_management_notifier.dart';
import '../../notifiers/mr_management_notifier.dart';
import '../../notifiers/trip_plan_notifier.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class CreateEditTripPlanScreen extends ConsumerStatefulWidget {
	const CreateEditTripPlanScreen({
		super.key,
		required this.subjectType,
		required this.subjectId,
	});

	final TripPlanSubjectType subjectType;
	final String subjectId;

	@override
	ConsumerState<CreateEditTripPlanScreen> createState() =>
			_CreateEditTripPlanScreenState();
}

class _CreateEditTripPlanScreenState
		extends ConsumerState<CreateEditTripPlanScreen> {
	DateTime _focusedDay = DateTime.now();
	DateTime? _selectedDay;

	final _planCtrl = TextEditingController();
	DateTime? _lastLoadedDay;

	@override
	void dispose() {
		_planCtrl.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final padding = AppLayout.pagePadding(context);
		final theme = Theme.of(context);
		final tripAsync = ref.watch(tripPlanNotifierProvider);
		final mrAsync = ref.watch(mrManagementNotifierProvider);
		final asmAsync = ref.watch(asmManagementNotifierProvider);

		final mrItems = mrAsync.maybeWhen(
			data: (items) => items,
			orElse: () => const <MrManagement>[],
		);
		final asmItems = asmAsync.maybeWhen(
			data: (items) => items,
			orElse: () => const <MrManagement>[],
		);

		MrManagement? subject;
		if (widget.subjectType == TripPlanSubjectType.mr) {
			try {
				subject = mrItems.firstWhere((e) => e.id == widget.subjectId);
			} catch (_) {
				subject = null;
			}
		} else {
			try {
				subject = asmItems.firstWhere((e) => e.id == widget.subjectId);
			} catch (_) {
				subject = null;
			}
		}

		final subjectName = subject?.name ?? widget.subjectId;
		final subtitle =
				subject == null ? 'Manage day plans' : '${subject.headquarter} • ${subject.phoneNumber}';

		final allPlans = tripAsync.asData?.value;
		TripPlan? plan;
		if (allPlans != null) {
			try {
				plan = allPlans.firstWhere(
					(e) => e.subjectType == widget.subjectType && e.subjectId == widget.subjectId,
				);
			} catch (_) {
				plan = null;
			}
		}

		final markedDays = <DateTime>{
			for (final d in plan?.days ?? const <TripPlanDayPlan>[]) if (d.items.isNotEmpty) tripPlanDayOnly(d.day),
		};

		final selectedDay = _selectedDay == null ? null : tripPlanDayOnly(_selectedDay!);
		final selectedItems = _itemsForDay(plan: plan, day: selectedDay);

		if (selectedDay != null && _lastLoadedDay != selectedDay) {
			_lastLoadedDay = selectedDay;
			_planCtrl.text = selectedItems.join('\n');
		}

		return Scaffold(
			appBar: AppAppBar(
				showLogo: false,
				title: '${widget.subjectType.label} Trip Plan',
				subtitle: subjectName,
				showMenuIfNoBack: false,
				showBackIfPossible: true,
			),
			body: SafeArea(
				child: SingleChildScrollView(
					padding: padding,
					child: Align(
						alignment: Alignment.topCenter,
						child: ConstrainedBox(
							constraints: const BoxConstraints(maxWidth: 1120),
							child: tripAsync.when(
								data: (_) {
									return Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: [
											_HeadlineCard(
												title: subjectName,
												subtitle: subtitle,
											),
											const SizedBox(height: 14),
											TripPlanCalendarCard(
												focusedDay: _focusedDay,
												selectedDay: _selectedDay,
												isMarked: (d) => markedDays.contains(tripPlanDayOnly(d)),
												onDaySelected: (sel, foc) {
													setState(() {
														_selectedDay = sel;
														_focusedDay = foc;
													});
												},
											),
											const SizedBox(height: 14),
											if (selectedDay == null)
												_EmptySelectDayCard(theme: theme)
											else ...[
												DayPlanCard(
													title: 'Day plan • ${MaterialLocalizations.of(context).formatMediumDate(selectedDay)}',
													items: selectedItems,
												),
												const SizedBox(height: 14),
												_EditCard(
													day: selectedDay,
													controller: _planCtrl,
													onSave: () => _save(selectedDay),
													onClear: () => _clear(selectedDay),
												),
											],
											const SizedBox(height: 92),
										],
									);
								},
								loading: () => _LoadingCard(theme: theme),
								error: (e, _) => const _ErrorCard(message: 'Failed to load trip plans.'),
							),
						),
					),
				),
			),
		);
	}

	List<String> _itemsForDay({required TripPlan? plan, required DateTime? day}) {
		if (plan == null || day == null) return const <String>[];
		for (final d in plan.days) {
			if (tripPlanDayOnly(d.day) == day) {
				return d.items;
			}
		}
		return const <String>[];
	}

	Future<void> _save(DateTime day) async {
		final items = _planCtrl.text
				.split('\n')
				.map((e) => e.trim())
				.where((e) => e.isNotEmpty)
				.toList(growable: false);

		await ref.read(tripPlanNotifierProvider.notifier).setDayPlan(
			subjectType: widget.subjectType,
			subjectId: widget.subjectId,
			day: day,
			items: items,
		);
	}

	Future<void> _clear(DateTime day) async {
		_planCtrl.clear();
		await ref.read(tripPlanNotifierProvider.notifier).setDayPlan(
			subjectType: widget.subjectType,
			subjectId: widget.subjectId,
			day: day,
			items: const <String>[],
		);
	}
}

class _HeadlineCard extends StatelessWidget {
	const _HeadlineCard({required this.title, required this.subtitle});

	final String title;
	final String subtitle;

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
				padding: const EdgeInsets.all(14),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						Text(
							title,
							style: theme.textTheme.titleMedium?.copyWith(
								fontWeight: FontWeight.w900,
								letterSpacing: -0.2,
							),
						),
						const SizedBox(height: 4),
						Text(
							subtitle,
							style: theme.textTheme.bodyMedium?.copyWith(
								fontWeight: FontWeight.w800,
								color: theme.colorScheme.onSurface.withAlpha(166),
							),
						),
					],
				),
			),
		);
	}
}

class _EditCard extends StatelessWidget {
	const _EditCard({
		required this.day,
		required this.controller,
		required this.onSave,
		required this.onClear,
	});

	final DateTime day;
	final TextEditingController controller;
	final VoidCallback onSave;
	final VoidCallback onClear;

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
				padding: const EdgeInsets.all(14),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						Text(
							'Edit / create day plan',
							style: theme.textTheme.titleMedium?.copyWith(
								fontWeight: FontWeight.w900,
								letterSpacing: -0.2,
							),
						),
						const SizedBox(height: 10),
						TextFormField(
							controller: controller,
							minLines: 4,
							maxLines: 10,
							decoration: const InputDecoration(
								labelText: 'Plan items (one per line)',
								hintText: 'Doctor visit - ...\nChemist visit - ...\nMeeting - ...',
							),
						),
						const SizedBox(height: 12),
						Row(
							children: [
								Expanded(
									child: OutlinedButton.icon(
										onPressed: onClear,
										icon: const Icon(Icons.delete_outline_rounded),
										label: const Text('Clear day plan'),
									),
								),
								const SizedBox(width: 12),
								Expanded(
									child: FilledButton.icon(
										onPressed: onSave,
										icon: const Icon(Icons.save_rounded),
										label: const Text('Save'),
									),
								),
							],
						),
					],
				),
			),
		);
	}
}

class _EmptySelectDayCard extends StatelessWidget {
	const _EmptySelectDayCard({required this.theme});

	final ThemeData theme;

	@override
	Widget build(BuildContext context) {
		final outline = theme.colorScheme.outline.withAlpha(204);
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
				child: Text(
					'Select a dotted date (or any date) to view and edit the day plan.',
					style: theme.textTheme.bodyMedium?.copyWith(
						fontWeight: FontWeight.w800,
						color: theme.colorScheme.onSurface.withAlpha(180),
					),
				),
			),
		);
	}
}

class _LoadingCard extends StatelessWidget {
	const _LoadingCard({required this.theme});

	final ThemeData theme;

	@override
	Widget build(BuildContext context) {
		final outline = theme.colorScheme.outline.withAlpha(204);
		return Card(
			elevation: 0,
			surfaceTintColor: Colors.transparent,
			color: theme.colorScheme.surface,
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(24),
				side: BorderSide(color: outline),
			),
			child: const Padding(
				padding: EdgeInsets.all(18),
				child: Row(
					children: [
						SizedBox(
							width: 18,
							height: 18,
							child: CircularProgressIndicator(strokeWidth: 2),
						),
						SizedBox(width: 12),
						Text('Loading trip plans...'),
					],
				),
			),
		);
	}
}

class _ErrorCard extends StatelessWidget {
	const _ErrorCard({required this.message});

	final String message;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(204);
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
				child: Text(
					message,
					style: theme.textTheme.bodyMedium?.copyWith(
						fontWeight: FontWeight.w800,
						color: theme.colorScheme.error,
					),
				),
			),
		);
	}
}
