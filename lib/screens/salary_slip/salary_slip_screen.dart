import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/salary_slip/employee_card.dart';
import '../../cards/salary_slip/employee_search_bar.dart';
import '../../cards/salary_slip/upload_salary_slip_bottomsheet.dart';
import '../../cards/salary_slip/view_salary_slip_bottomsheet.dart';
import '../../models/mr_management.dart';
import '../../models/salary_slip.dart';
import '../../notifiers/asm_management_notifier.dart';
import '../../notifiers/mr_management_notifier.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';

class SalarySlipScreen extends ConsumerStatefulWidget {
  const SalarySlipScreen({super.key});

  @override
  ConsumerState<SalarySlipScreen> createState() => _SalarySlipScreenState();
}

class _SalarySlipScreenState extends ConsumerState<SalarySlipScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = AppLayout.pagePadding(context);

    final mrsAsync = ref.watch(mrManagementNotifierProvider);
    final asmsAsync = ref.watch(asmManagementNotifierProvider);

    final employees = <_Employee>[
      ..._toEmployees(
        items: mrsAsync.asData?.value,
        type: SalarySlipEmployeeType.mr,
      ),
      ..._toEmployees(
        items: asmsAsync.asData?.value,
        type: SalarySlipEmployeeType.asm,
      ),
    ]..sort((l, r) => l.name.toLowerCase().compareTo(r.name.toLowerCase()));

    final isLoading = mrsAsync.isLoading || asmsAsync.isLoading;
    final hasAnyError = mrsAsync.hasError || asmsAsync.hasError;

    final q = _query.trim().toLowerCase();
    final filtered = (q.isEmpty)
        ? employees
        : employees.where((e) {
            return e.name.toLowerCase().contains(q) ||
                e.phoneNumber.toLowerCase().contains(q) ||
                e.email.toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      appBar: const AppAppBar(
        showLogo: false,
        showBackIfPossible: false,
        title: 'Salary Slip Management',
        subtitle: 'Upload and view salary slips',
        showMenuIfNoBack: true,
      ),
      drawer: SideNavBarDrawer(
        companyName: 'Naiyo24',
        tagline: 'Admin console',
        selectedIndex: SideNavBarDrawer.destinations.indexOf(
          SideNavDestination.salarySlipManagement,
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
                  EmployeeSearchBar(
                    hintText: 'Search MR/ASM by name, phone, or email',
                    onChanged: (v) => setState(() => _query = v),
                  ),
                  const SizedBox(height: 14),
                  if (isLoading && employees.isEmpty)
                    _LoadingCard(theme: theme)
                  else if (hasAnyError && employees.isEmpty)
                    const _ErrorCard(message: 'Failed to load MR/ASM list.')
                  else if (filtered.isEmpty)
                    _EmptyCard(theme: theme)
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final e in filtered) ...[
                          EmployeeCard(
                            name: e.name,
                            phoneNumber: e.phoneNumber,
                            email: e.email,
                            onUpload: () => _openUploadSheet(e),
                            onView: () => _openViewSheet(e),
                          ),
                          const SizedBox(height: 12),
                        ],
                        const SizedBox(height: 92),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static List<_Employee> _toEmployees({
    required List<MrManagement>? items,
    required SalarySlipEmployeeType type,
  }) {
    if (items == null) return const <_Employee>[];
    return items
        .map(
          (m) => _Employee(
            type: type,
            id: m.id,
            name: m.name,
            phoneNumber: m.phoneNumber,
            email: m.email ?? '',
          ),
        )
        .toList(growable: false);
  }

  Future<void> _openUploadSheet(_Employee employee) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return UploadSalarySlipBottomSheet(
          employeeType: employee.type,
          employeeId: employee.id,
          employeeName: employee.name,
        );
      },
    );
  }

  Future<void> _openViewSheet(_Employee employee) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return ViewSalarySlipBottomSheet(
          employeeType: employee.type,
          employeeId: employee.id,
          employeeName: employee.name,
        );
      },
    );
  }
}

class _Employee {
  const _Employee({
    required this.type,
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
  });

  final SalarySlipEmployeeType type;
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.theme});

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
          'No employees found. Try a different search.',
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
            Text('Loading employees...'),
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
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
