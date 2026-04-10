
import 'dart:typed_data';


import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cards/trip_plan/trip_plan_card.dart';
import '../../cards/trip_plan/trip_plan_search_bar.dart';
import '../../models/mr_management.dart';
import '../../models/trip_plan.dart';
import '../../notifiers/asm_management_notifier.dart';
import '../../notifiers/mr_management_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';

class TripPlanScreen extends ConsumerStatefulWidget {
	const TripPlanScreen({super.key});

	@override
	ConsumerState<TripPlanScreen> createState() => _TripPlanScreenState();
}

class _TripPlanScreenState extends ConsumerState<TripPlanScreen> {
	String _query = '';

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final padding = AppLayout.pagePadding(context);
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

		final subjects = <({
			TripPlanSubjectType type,
			String id,
			String name,
			String phone,
			String hq,
			Uint8List? photo,
		})>[];

		for (final mr in mrItems) {
			subjects.add((
				type: TripPlanSubjectType.mr,
				id: mr.id,
				name: mr.name,
				phone: mr.phoneNumber,
				hq: mr.headquarter,
				photo: mr.photoBytes,
			));
		}
		for (final asm in asmItems) {
			subjects.add((
				type: TripPlanSubjectType.asm,
				id: asm.id,
				name: asm.name,
				phone: asm.phoneNumber,
				hq: asm.headquarter,
				photo: asm.photoBytes,
			));
		}
		subjects.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

		final q = _query.trim().toLowerCase();
		final filtered = subjects.where((s) {
			if (q.isEmpty) return true;
			return s.name.toLowerCase().contains(q) ||
				s.phone.toLowerCase().contains(q) ||
				s.hq.toLowerCase().contains(q) ||
				s.type.label.toLowerCase().contains(q);
		}).toList(growable: false);

		return Scaffold(
			appBar: const AppAppBar(
				showLogo: false,
				showBackIfPossible: false,
				title: 'Trip Plan Management',
				subtitle: 'Search and manage day plans',
				showMenuIfNoBack: true,
			),
			drawer: SideNavBarDrawer(
				companyName: 'Naiyo24',
				tagline: 'Admin console',
				selectedIndex: SideNavBarDrawer.destinations.indexOf(
					SideNavDestination.tripPlanManagement,
				),
			),
			body: SafeArea(
				child: SingleChildScrollView(
					padding: padding,
					child: Align(
						alignment: Alignment.topCenter,
						child: ConstrainedBox(
							constraints: const BoxConstraints(maxWidth: 1120),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.stretch,
								children: [
									TripPlanSearchBar(
										onQueryChanged: (v) => setState(() => _query = v),
									),
									const SizedBox(height: 14),
									if (subjects.isEmpty)
										_EmptyCard(theme: theme)
									else if (filtered.isEmpty)
										_EmptyCard(
											theme: theme,
											message: 'No MR/ASM found. Try a different search.',
										)
									else
										Column(
											crossAxisAlignment: CrossAxisAlignment.stretch,
											children: [
												for (final s in filtered) ...[
													TripPlanCard(
														subjectType: s.type,
														name: s.name,
														phoneNumber: s.phone,
														headquarter: s.hq,
														photoBytes: s.photo,
														onTap: () => context.goNamed(
														AppRoutes.tripPlanEditor,
														pathParameters: {
															'subjectType': s.type.name,
															'subjectId': s.id,
														},
													),
												),
												const SizedBox(height: 12),
											],
										],
									),
									const SizedBox(height: 92),
								],
							),
						),
					),
				),
			),
		);
	}
}

class _EmptyCard extends StatelessWidget {
	const _EmptyCard({required this.theme, this.message});

	final ThemeData theme;
	final String? message;

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
					message ?? 'No MR/ASM records found.',
					style: theme.textTheme.bodyMedium?.copyWith(
						fontWeight: FontWeight.w800,
						color: theme.colorScheme.onSurface.withAlpha(180),
					),
				),
			),
		);
	}
}
