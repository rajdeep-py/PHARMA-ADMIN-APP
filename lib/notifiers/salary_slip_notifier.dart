import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/salary_slip.dart';
import '../providers/salary_slip_provider.dart';

class SalarySlipNotifier extends AsyncNotifier<List<SalarySlip>> {
  @override
  Future<List<SalarySlip>> build() async {
    final repo = ref.read(salarySlipRepositoryProvider);
    return repo.list();
  }

  Future<void> refreshList() async {
    state = const AsyncLoading();
    final repo = ref.read(salarySlipRepositoryProvider);
    state = AsyncData(await repo.list());
  }

  Future<void> upload({
    required SalarySlipEmployeeType employeeType,
    required String employeeId,
    required int month,
    required int year,
    required String filePath,
    required String fileName,
  }) async {
    final repo = ref.read(salarySlipRepositoryProvider);
    final now = DateTime.now();
    final slip = SalarySlip(
      id: 'ss_${now.millisecondsSinceEpoch}',
      employeeType: employeeType,
      employeeId: employeeId,
      month: month,
      year: year,
      filePath: filePath,
      fileName: fileName,
      uploadedAt: now,
    );
    await repo.upsert(slip);
    await refreshList();
  }

  Future<SalarySlip?> findForPeriod({
    required SalarySlipEmployeeType employeeType,
    required String employeeId,
    required int month,
    required int year,
  }) {
    final repo = ref.read(salarySlipRepositoryProvider);
    return repo.find(
      employeeType: employeeType,
      employeeId: employeeId,
      month: month,
      year: year,
    );
  }
}

final salarySlipNotifierProvider =
    AsyncNotifierProvider<SalarySlipNotifier, List<SalarySlip>>(
      SalarySlipNotifier.new,
    );
