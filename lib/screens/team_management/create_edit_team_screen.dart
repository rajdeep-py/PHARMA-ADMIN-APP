
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/team_management.dart';
import '../../notifiers/team_management_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class CreateEditTeamScreen extends ConsumerStatefulWidget {
	const CreateEditTeamScreen({super.key, this.teamId});

	final String? teamId;

	@override
	ConsumerState<CreateEditTeamScreen> createState() =>
			_CreateEditTeamScreenState();
}

class _CreateEditTeamScreenState extends ConsumerState<CreateEditTeamScreen> {
	final _formKey = GlobalKey<FormState>();
	final _nameCtrl = TextEditingController();
	final _descCtrl = TextEditingController();

	Uint8List? _photoBytes;
	bool _initialized = false;

	@override
	void dispose() {
		_nameCtrl.dispose();
		_descCtrl.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final padding = AppLayout.pagePadding(context);
		final teamsAsync = ref.watch(teamManagementNotifierProvider);
		final isEdit = widget.teamId != null;

		final existing = teamsAsync.maybeWhen(
			data: (items) => (widget.teamId == null)
					? null
					: items.where((e) => e.id == widget.teamId).firstOrNull,
			orElse: () => null,
		);

		if (!_initialized && existing != null) {
			_initialized = true;
			_nameCtrl.text = existing.name;
			_descCtrl.text = existing.description;
			_photoBytes = existing.photoBytes;
		}

		return Scaffold(
			appBar: AppAppBar(
				showLogo: false,
				showBackIfPossible: true,
				showMenuIfNoBack: false,
				title: isEdit ? 'Edit Team' : 'Create Team',
				subtitle: isEdit ? 'Update team details' : 'Set up a new team',
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
										_ImagePickerCard(
											imageBytes: _photoBytes,
											onPick: _pickImage,
										),
										const SizedBox(height: 14),
										_CardSection(
											title: 'Team details',
											icon: Icons.hub_rounded,
											child: Column(
												children: [
													TextFormField(
														controller: _nameCtrl,
														validator: (v) {
															if (v == null || v.trim().isEmpty) {
																return 'Team name is required.';
															}
															return null;
														},
														decoration: const InputDecoration(
															labelText: 'Team name',
														),
													),
													const SizedBox(height: 12),
													TextFormField(
														controller: _descCtrl,
														minLines: 3,
														maxLines: 6,
														decoration: const InputDecoration(
															labelText: 'Team description',
														),
													),
												],
											),
										),
										const SizedBox(height: 16),
										Align(
											alignment: Alignment.centerRight,
											child: FilledButton.icon(
												onPressed: teamsAsync.isLoading ? null : _save,
												icon: const Icon(Icons.save_rounded),
												label: Text(isEdit ? 'Save changes' : 'Create team'),
											),
										),
									],
								),
							),
						),
					),
				),
			),
		);
	}

	Future<void> _pickImage() async {
		final source = await showModalBottomSheet<ImageSource>(
			context: context,
			showDragHandle: true,
			builder: (context) {
				final theme = Theme.of(context);
				return SafeArea(
					child: Padding(
						padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
						child: Column(
							mainAxisSize: MainAxisSize.min,
							children: [
								ListTile(
									leading: Icon(
										Icons.camera_alt_rounded,
										color: theme.colorScheme.primary,
									),
									title: const Text('Camera'),
									onTap: () => Navigator.of(context).pop(ImageSource.camera),
								),
								ListTile(
									leading: Icon(
										Icons.photo_library_rounded,
										color: theme.colorScheme.primary,
									),
									title: const Text('Gallery'),
									onTap: () => Navigator.of(context).pop(ImageSource.gallery),
								),
							],
						),
					),
				);
			},
		);

		if (source == null) return;
		final picker = ImagePicker();
		final file = await picker.pickImage(source: source, imageQuality: 90);
		if (file == null) return;
		final bytes = await file.readAsBytes();
		if (!mounted) return;
		setState(() => _photoBytes = bytes);
	}

	Future<void> _save() async {
		final ok = _formKey.currentState?.validate() ?? false;
		if (!ok) return;

		final teams = ref.read(teamManagementNotifierProvider).asData?.value;
		final existing = (widget.teamId == null || teams == null)
				? null
				: teams.where((e) => e.id == widget.teamId).firstOrNull;

		final id = widget.teamId ??
				'team_${DateTime.now().millisecondsSinceEpoch.toString()}';
		final team = TeamManagement(
			id: id,
			name: _nameCtrl.text.trim(),
			description: _descCtrl.text.trim(),
			photoBytes: _photoBytes,
			members: existing?.members ?? const <TeamMember>[],
			messages: existing?.messages ?? const <TeamChatMessage>[],
		);

		await ref.read(teamManagementNotifierProvider.notifier).upsertTeam(team);
		if (!mounted) return;
		context.goNamed(AppRoutes.teamManagement);
	}
}

class _ImagePickerCard extends StatelessWidget {
	const _ImagePickerCard({required this.imageBytes, required this.onPick});

	final Uint8List? imageBytes;
	final VoidCallback onPick;

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
				padding: const EdgeInsets.all(18),
				child: Row(
					children: [
						Container(
							width: 110,
							height: 74,
							decoration: BoxDecoration(
								borderRadius: BorderRadius.circular(18),
								border: Border.all(color: outline),
							),
							clipBehavior: Clip.antiAlias,
							child: (imageBytes == null)
									? Container(
											color: theme.colorScheme.primary.withAlpha(10),
											child: Icon(
												Icons.image_rounded,
												color: theme.colorScheme.primary,
											),
										)
									: Image.memory(imageBytes!, fit: BoxFit.cover),
						),
						const SizedBox(width: 14),
						Expanded(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										'Team image',
										style: theme.textTheme.titleSmall?.copyWith(
											fontWeight: FontWeight.w900,
										),
									),
									const SizedBox(height: 4),
									Text(
										'Upload from camera or gallery',
										style: theme.textTheme.bodySmall?.copyWith(
											color: theme.colorScheme.onSurface.withAlpha(166),
											fontWeight: FontWeight.w800,
										),
									),
								],
							),
						),
						const SizedBox(width: 10),
						FilledButton.icon(
							onPressed: onPick,
							icon: const Icon(Icons.upload_rounded),
							label: const Text('Upload'),
						),
					],
				),
			),
		);
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
				padding: const EdgeInsets.all(18),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Row(
							children: [
								Icon(icon, color: theme.colorScheme.primary),
								const SizedBox(width: 10),
								Text(
									title,
									style: theme.textTheme.titleSmall?.copyWith(
										fontWeight: FontWeight.w900,
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

