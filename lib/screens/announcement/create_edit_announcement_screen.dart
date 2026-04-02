import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/announcement.dart';
import '../../notifiers/announcement_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class CreateEditAnnouncementScreen extends ConsumerStatefulWidget {
	const CreateEditAnnouncementScreen({super.key, this.announcementId});

	final String? announcementId;

	@override
	ConsumerState<CreateEditAnnouncementScreen> createState() =>
			_CreateEditAnnouncementScreenState();
}

class _CreateEditAnnouncementScreenState
		extends ConsumerState<CreateEditAnnouncementScreen> {
	final _formKey = GlobalKey<FormState>();
	final _headlineCtrl = TextEditingController();
	final _descCtrl = TextEditingController();

	bool _initialized = false;

	@override
	void dispose() {
		_headlineCtrl.dispose();
		_descCtrl.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final padding = AppLayout.pagePadding(context);
		final listAsync = ref.watch(announcementNotifierProvider);
		final isEdit = widget.announcementId != null;

		final existing = listAsync.maybeWhen(
			data: (items) => (widget.announcementId == null)
					? null
					: items.where((e) => e.id == widget.announcementId).firstOrNull,
			orElse: () => null,
		);

		if (!_initialized && existing != null) {
			_initialized = true;
			_headlineCtrl.text = existing.headline;
			_descCtrl.text = existing.description;
		}

		return Scaffold(
			appBar: AppAppBar(
				showLogo: false,
				showBackIfPossible: true,
				showMenuIfNoBack: false,
				title: isEdit ? 'Edit Announcement' : 'Create Announcement',
				subtitle: isEdit
						? 'Update announcement details'
						: 'Publish a new announcement',
			),
			body: SafeArea(
				child: SingleChildScrollView(
					padding: padding,
					child: Align(
						alignment: Alignment.topCenter,
						child: ConstrainedBox(
							constraints: const BoxConstraints(maxWidth: 1120),
							child: Form(
								key: _formKey,
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.stretch,
									children: [
										_CardSection(
											title: 'Announcement details',
											icon: Icons.notifications_active_rounded,
											child: Column(
												children: [
													TextFormField(
														controller: _headlineCtrl,
														validator: (v) {
															if (v == null || v.trim().isEmpty) {
																return 'Headline is required.';
															}
															return null;
														},
														decoration: const InputDecoration(
															labelText: 'Headline',
														),
													),
													const SizedBox(height: 12),
													TextFormField(
														controller: _descCtrl,
														minLines: 4,
														maxLines: 8,
														validator: (v) {
															if (v == null || v.trim().isEmpty) {
																return 'Description is required.';
															}
															return null;
														},
														decoration: const InputDecoration(
															labelText: 'Description',
														),
													),
											],
										),
									),
									const SizedBox(height: 16),
									Align(
										alignment: Alignment.centerRight,
										child: FilledButton.icon(
											onPressed: listAsync.isLoading ? null : _save,
											icon: const Icon(Icons.save_rounded),
											label: Text(
												isEdit ? 'Save changes' : 'Create announcement',
											),
										),
									),
									const SizedBox(height: 80),
								],
							),
						),
					),
				),
			),
		),
    );
	}

	Future<void> _save() async {
		final ok = _formKey.currentState?.validate() ?? false;
		if (!ok) return;

		final list = ref.read(announcementNotifierProvider).asData?.value;
		final existing = (widget.announcementId == null || list == null)
				? null
				: list.where((e) => e.id == widget.announcementId).firstOrNull;

		final now = DateTime.now();
		final id = widget.announcementId ??
				'an_${DateTime.now().millisecondsSinceEpoch.toString()}';
		final a = Announcement(
			id: id,
			headline: _headlineCtrl.text.trim(),
			description: _descCtrl.text.trim(),
			createdAt: existing?.createdAt ?? now,
			updatedAt: now,
		);

		await ref.read(announcementNotifierProvider.notifier).upsert(a);
		if (!mounted) return;
		context.goNamed(AppRoutes.announcementManagement);
	}
}

class _CardSection extends StatelessWidget {
	const _CardSection({
		required this.title,
		required this.icon,
		required this.child,
	});

	final String title;
	final IconData icon;
	final Widget child;

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
				padding: const EdgeInsets.all(16),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						Row(
							children: [
								Icon(icon, color: theme.colorScheme.primary),
								const SizedBox(width: 10),
								Expanded(
									child: Text(
										title,
										style: theme.textTheme.titleMedium?.copyWith(
											fontWeight: FontWeight.w900,
											letterSpacing: -0.2,
										),
									),
								),
							],
						),
						const SizedBox(height: 12),
						child,
					],
				),
			),
		);
	}
}

extension FirstOrNullX<T> on Iterable<T> {
	T? get firstOrNull => isEmpty ? null : first;
}

