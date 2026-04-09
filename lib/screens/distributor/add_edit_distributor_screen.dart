import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/distributor.dart';
import '../../models/mr_management.dart';
import '../../notifiers/asm_management_notifier.dart';
import '../../notifiers/distributor_notifier.dart';
import '../../notifiers/mr_management_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class AddEditDistributorScreen extends ConsumerStatefulWidget {
	const AddEditDistributorScreen({super.key, this.distributorId});

	final String? distributorId;

	@override
	ConsumerState<AddEditDistributorScreen> createState() =>
			_AddEditDistributorScreenState();
}

class _AddEditDistributorScreenState
		extends ConsumerState<AddEditDistributorScreen> {
	final _formKey = GlobalKey<FormState>();

	final _nameCtrl = TextEditingController();
	final _addressCtrl = TextEditingController();
	final _photoCtrl = TextEditingController();
	final _descCtrl = TextEditingController();
	final _minOrderCtrl = TextEditingController();
	final _deliveryCtrl = TextEditingController();
	final _productsCtrl = TextEditingController();
	final _phoneCtrl = TextEditingController();
	final _emailCtrl = TextEditingController();

	Uint8List? _photoBytes;

	DistributorAddedByType _addedByType = DistributorAddedByType.mr;
	String? _addedById;

	bool _initialized = false;

	@override
	void dispose() {
		_nameCtrl.dispose();
		_addressCtrl.dispose();
		_photoCtrl.dispose();
		_descCtrl.dispose();
		_minOrderCtrl.dispose();
		_deliveryCtrl.dispose();
		_productsCtrl.dispose();
		_phoneCtrl.dispose();
		_emailCtrl.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final padding = AppLayout.pagePadding(context);
		final isEdit = widget.distributorId != null;
		final listAsync = ref.watch(distributorNotifierProvider);
		final mrAsync = ref.watch(mrManagementNotifierProvider);
		final asmAsync = ref.watch(asmManagementNotifierProvider);

		Distributor? existing;
		if (isEdit) {
			existing = listAsync.maybeWhen(
				data: (items) {
					try {
						return items.firstWhere((d) => d.id == widget.distributorId);
					} catch (_) {
						return null;
					}
				},
				orElse: () => null,
			);
		}

		if (!_initialized && existing != null) {
			_initialized = true;
			_nameCtrl.text = existing.name;
			_addressCtrl.text = existing.address;
			_photoCtrl.text = existing.photoPath;
			_photoBytes = existing.photoBytes;
			_descCtrl.text = existing.description;
			_minOrderCtrl.text = existing.minimumOrderValue.toStringAsFixed(0);
			_deliveryCtrl.text = existing.expectedDeliveryTime;
			_productsCtrl.text = existing.productsAvailable.join(', ');
			_phoneCtrl.text = existing.phoneNumber;
			_emailCtrl.text = existing.email;
			_addedByType = existing.addedByType;
			_addedById = existing.addedById;
		}

		final mrItems = mrAsync.maybeWhen(
			data: (items) => items,
			orElse: () => const <MrManagement>[],
		);
		final asmItems = asmAsync.maybeWhen(
			data: (items) => items,
			orElse: () => const <MrManagement>[],
		);

		final addedByOptions = _addedByType == DistributorAddedByType.mr
				? mrItems
				: asmItems;

		return Scaffold(
			appBar: AppAppBar(
				showLogo: false,
				title: isEdit ? 'Edit Distributor' : 'Add Distributor',
				subtitle: isEdit
						? 'Update distributor details'
						: 'Create a new distributor',
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
							child: Form(
								key: _formKey,
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.stretch,
									children: [
										_CardSection(
											title: 'Distributor details',
											icon: Icons.inventory_2_rounded,
											child: Column(
												children: [
													_PhotoPickerCard(
														photoBytes: _photoBytes,
														photoPath: _photoCtrl.text.trim(),
														onPick: _pickPhoto,
														onRemove: () => setState(() => _photoBytes = null),
													),
													const SizedBox(height: 12),
													TextFormField(
														controller: _nameCtrl,
														validator: (v) {
															if (v == null || v.trim().isEmpty) {
																return 'Name is required.';
															}
															return null;
														},
														decoration: const InputDecoration(
															labelText: 'Distributor name',
														),
													),
													const SizedBox(height: 12),
													TextFormField(
														controller: _addressCtrl,
														validator: (v) {
															if (v == null || v.trim().isEmpty) {
																return 'Address is required.';
															}
															return null;
														},
														decoration: const InputDecoration(
															labelText: 'Address',
														),
													),
													const SizedBox(height: 12),
													TextFormField(
														controller: _photoCtrl,
														decoration: const InputDecoration(
															labelText: 'Photo URL / asset path (optional)',
														),
													),
													const SizedBox(height: 12),
													DropdownButtonFormField<DistributorAddedByType>(
														initialValue: _addedByType,
														decoration: const InputDecoration(
															labelText: 'Added by',
														),
														items: const [
															DropdownMenuItem(
																value: DistributorAddedByType.mr,
																child: Text('MR'),
															),
															DropdownMenuItem(
																value: DistributorAddedByType.asm,
																child: Text('ASM'),
															),
														],
														onChanged: (v) {
															if (v == null) return;
															setState(() {
																_addedByType = v;
																_addedById = null;
															});
														},
													),
													const SizedBox(height: 12),
													DropdownButtonFormField<String>(
														initialValue: _addedById,
														decoration: const InputDecoration(
															labelText: 'Select person',
														),
														items: [
															for (final p in addedByOptions)
																DropdownMenuItem<String>(
																	value: p.id,
																	child: Text(p.name),
																),
														],
														onChanged: (v) => setState(() => _addedById = v),
														validator: (v) {
															if (v == null || v.trim().isEmpty) {
																return 'Select a person.';
															}
															return null;
														},
													),
													const SizedBox(height: 12),
													TextFormField(
														controller: _descCtrl,
														minLines: 3,
														maxLines: 6,
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
										_CardSection(
											title: 'Order info',
											icon: Icons.local_shipping_rounded,
											child: Column(
												children: [
													TextFormField(
														controller: _minOrderCtrl,
														keyboardType: const TextInputType.numberWithOptions(
															decimal: true,
														),
														validator: (v) {
															if (v == null || v.trim().isEmpty) {
																return 'Minimum order value is required.';
															}
															final n = double.tryParse(v.trim());
															if (n == null || n <= 0) {
																return 'Enter a valid amount.';
															}
															return null;
														},
														decoration: const InputDecoration(
															labelText: 'Minimum order value',
														),
													),
													const SizedBox(height: 12),
													TextFormField(
														controller: _deliveryCtrl,
														validator: (v) {
															if (v == null || v.trim().isEmpty) {
																return 'Expected delivery time is required.';
															}
															return null;
														},
														decoration: const InputDecoration(
															labelText: 'Expected delivery time',
														),
													),
													const SizedBox(height: 12),
													TextFormField(
														controller: _productsCtrl,
														decoration: const InputDecoration(
															labelText: 'Products available (comma separated)',
														),
													),
												],
											),
										),
										const SizedBox(height: 16),
										_CardSection(
											title: 'Contact',
											icon: Icons.contact_phone_rounded,
											child: Column(
												children: [
													TextFormField(
														controller: _phoneCtrl,
														validator: (v) {
															if (v == null || v.trim().isEmpty) {
																return 'Phone number is required.';
															}
															return null;
														},
														decoration: const InputDecoration(
															labelText: 'Phone number',
														),
													),
													const SizedBox(height: 12),
													TextFormField(
														controller: _emailCtrl,
														validator: (v) {
															if (v == null || v.trim().isEmpty) {
																return 'Email is required.';
															}
															return null;
														},
														decoration: const InputDecoration(
															labelText: 'Email',
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
												label: Text(isEdit ? 'Save changes' : 'Add distributor'),
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

		final mrList = ref.read(mrManagementNotifierProvider).asData?.value ?? [];
		final asmList =
				ref.read(asmManagementNotifierProvider).asData?.value ?? [];

		final picked = _addedByType == DistributorAddedByType.mr
				? mrList.where((e) => e.id == _addedById).cast<MrManagement?>().firstOrNull
				: asmList.where((e) => e.id == _addedById).cast<MrManagement?>().firstOrNull;

		final products = _productsCtrl.text
				.split(',')
				.map((e) => e.trim())
				.where((e) => e.isNotEmpty)
				.toList(growable: false);

		final id = widget.distributorId ??
				'dist_${DateTime.now().millisecondsSinceEpoch.toString()}';

		final distributor = Distributor(
			id: id,
			name: _nameCtrl.text.trim(),
			address: _addressCtrl.text.trim(),
			photoPath: _photoCtrl.text.trim(),
			photoBytes: _photoBytes,
			addedByType: _addedByType,
			addedById: _addedById ?? '',
			addedByName: picked?.name ?? '',
			description: _descCtrl.text.trim(),
			minimumOrderValue: double.parse(_minOrderCtrl.text.trim()),
			expectedDeliveryTime: _deliveryCtrl.text.trim(),
			productsAvailable: products,
			phoneNumber: _phoneCtrl.text.trim(),
			email: _emailCtrl.text.trim(),
		);

		await ref.read(distributorNotifierProvider.notifier).upsert(distributor);
		if (!mounted) return;
		context.goNamed(AppRoutes.distributorManagement);
	}

	Future<void> _pickPhoto() async {
		final source = await showModalBottomSheet<_PhotoSource>(
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
									onTap: () =>
										Navigator.of(context).pop(_PhotoSource.camera),
								),
								ListTile(
									leading: Icon(
										Icons.photo_library_rounded,
										color: theme.colorScheme.primary,
									),
									title: const Text('Gallery'),
									onTap: () =>
										Navigator.of(context).pop(_PhotoSource.gallery),
								),
								ListTile(
									leading: Icon(
										Icons.folder_open_rounded,
										color: theme.colorScheme.primary,
									),
									title: const Text('Files'),
									onTap: () =>
										Navigator.of(context).pop(_PhotoSource.files),
								),
							],
						),
					),
				);
			},
		);

		if (source == null) return;

		if (source == _PhotoSource.files) {
			final result = await FilePicker.platform.pickFiles(
				allowMultiple: false,
				type: FileType.image,
				withData: true,
				dialogTitle: 'Select distributor photo',
			);

			final file = result?.files.single;
			final bytes = file?.bytes;
			if (bytes == null) return;
			if (!mounted) return;
			setState(() {
				_photoBytes = bytes;
			});
			return;
		}

		final imageSource = (source == _PhotoSource.camera)
				? ImageSource.camera
				: ImageSource.gallery;
		final picker = ImagePicker();
		final file = await picker.pickImage(source: imageSource, imageQuality: 88);
		if (file == null) return;
		final bytes = await file.readAsBytes();
		if (!mounted) return;
		setState(() {
			_photoBytes = bytes;
		});
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

extension _FirstOrNullX<T> on Iterable<T> {
	T? get firstOrNull => isEmpty ? null : first;
}

enum _PhotoSource { camera, gallery, files }

class _PhotoPickerCard extends StatelessWidget {
	const _PhotoPickerCard({
		required this.photoBytes,
		required this.photoPath,
		required this.onPick,
		required this.onRemove,
	});

	final Uint8List? photoBytes;
	final String photoPath;
	final VoidCallback onPick;
	final VoidCallback onRemove;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		Widget preview;
		if (photoBytes != null) {
			preview = Image.memory(photoBytes!, fit: BoxFit.cover);
		} else if (photoPath.trim().isNotEmpty && photoPath.trim().startsWith('assets/')) {
			preview = Image.asset(photoPath.trim(), fit: BoxFit.cover);
		} else if (photoPath.trim().isNotEmpty) {
			preview = Image.network(
				photoPath.trim(),
				fit: BoxFit.cover,
				errorBuilder: (_, _, _) {
					return Center(
						child: Icon(
							Icons.inventory_2_rounded,
							color: theme.colorScheme.primary,
							size: 28,
						),
					);
				},
			);
		} else {
			preview = Center(
				child: Icon(
					Icons.inventory_2_rounded,
					color: theme.colorScheme.primary,
					size: 28,
				),
			);
		}

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
				child: Row(
					children: [
						Container(
							width: 84,
							height: 84,
							decoration: BoxDecoration(
								borderRadius: BorderRadius.circular(22),
								color: theme.colorScheme.primary.withAlpha(10),
								border: Border.all(color: outline),
							),
							clipBehavior: Clip.antiAlias,
							child: preview,
						),
						const SizedBox(width: 12),
						Expanded(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										'Distributor photo',
										style: theme.textTheme.titleMedium?.copyWith(
											fontWeight: FontWeight.w900,
											letterSpacing: -0.2,
										),
									),
									const SizedBox(height: 6),
									Wrap(
										spacing: 10,
										runSpacing: 10,
										children: [
											FilledButton.icon(
												onPressed: onPick,
												icon: const Icon(Icons.photo_camera_rounded),
												label: const Text('Change'),
											),
											OutlinedButton.icon(
												onPressed: (photoBytes == null && photoPath.trim().isEmpty)
													? null
													: onRemove,
												icon: const Icon(Icons.delete_outline_rounded),
												label: const Text('Remove'),
											),
										],
									),
								],
							),
						),
					],
				),
			),
		);
	}
}

