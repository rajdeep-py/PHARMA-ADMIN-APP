import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/asm_management/asm_bank_details_card.dart';
import '../../cards/asm_management/asm_contact_card.dart';
import '../../cards/asm_management/asm_header_card.dart';
import '../../cards/asm_management/asm_headquarter_card.dart';
import '../../notifiers/asm_management_notifier.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class AsmDetailsScreen extends ConsumerWidget {
	const AsmDetailsScreen({super.key, required this.asmId});

	final String asmId;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final theme = Theme.of(context);
		final padding = AppLayout.pagePadding(context);
		final listAsync = ref.watch(asmManagementNotifierProvider);

		return Scaffold(
			appBar: const AppAppBar(
				showLogo: false,
				showBackIfPossible: true,
				showMenuIfNoBack: false,
				title: 'ASM Details',
				subtitle: 'Profile & information',
			),
			body: SafeArea(
				child: SingleChildScrollView(
					padding: padding,
					child: Align(
						alignment: Alignment.topCenter,
						child: ConstrainedBox(
							constraints: const BoxConstraints(maxWidth: 1120),
							child: listAsync.when(
								data: (items) {
									final asm = items.where((e) => e.id == asmId).firstOrNull;
									if (asm == null) {
										return const _ErrorCard(message: 'ASM not found.');
									}

									return Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: [
											AsmHeaderCard(
												photoBytes: asm.photoBytes,
												name: asm.name,
												password: asm.password,
											),
											const SizedBox(height: 14),
											AsmHeadquarterCard(
												headquarter: asm.headquarter,
												territories: asm.territories,
											),
											const SizedBox(height: 14),
											AsmBankDetailsCard(
												bankName: asm.bankName,
												bankAccountNumber: asm.bankAccountNumber,
												ifscCode: asm.ifscCode,
												upiId: asm.upiId,
												branchName: asm.branchName,
											),
											const SizedBox(height: 14),
											AsmContactCard(
												phoneNumber: asm.phoneNumber,
												alternativePhoneNumber:
													asm.alternativePhoneNumber,
												email: asm.email,
												address: asm.address,
											),
										],
									);
								},
								loading: () => _LoadingCard(theme: theme),
								error: (e, _) => const _ErrorCard(
									message: 'Failed to load ASM details.',
								),
							),
						),
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
						Text('Loading ASM...'),
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
						color: theme.colorScheme.error,
						fontWeight: FontWeight.w700,
					),
				),
			),
		);
	}
}

extension FirstOrNullX<T> on Iterable<T> {
	T? get firstOrNull => isEmpty ? null : first;
}

