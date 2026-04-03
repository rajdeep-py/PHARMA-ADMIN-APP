import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/salary_slip.dart';

abstract class SalarySlipRepository {
  Future<List<SalarySlip>> list();

  Future<void> upsert(SalarySlip slip);

  Future<SalarySlip?> find({
    required SalarySlipEmployeeType employeeType,
    required String employeeId,
    required int month,
    required int year,
  });
}

class InMemorySalarySlipRepository implements SalarySlipRepository {
  InMemorySalarySlipRepository();

  final List<SalarySlip> _items = <SalarySlip>[];

  @override
  Future<List<SalarySlip>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final items = [..._items]
      ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    return List<SalarySlip>.unmodifiable(items);
  }

  @override
  Future<void> upsert(SalarySlip slip) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));

    final idx = _items.indexWhere((e) {
      return e.employeeType == slip.employeeType &&
          e.employeeId == slip.employeeId &&
          e.month == slip.month &&
          e.year == slip.year;
    });

    if (idx >= 0) {
      final existing = _items[idx];
      _items[idx] = slip.copyWith(id: existing.id);
      return;
    }

    _items.insert(0, slip);
  }

  @override
  Future<SalarySlip?> find({
    required SalarySlipEmployeeType employeeType,
    required String employeeId,
    required int month,
    required int year,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    try {
      return _items.firstWhere((e) {
        return e.employeeType == employeeType &&
            e.employeeId == employeeId &&
            e.month == month &&
            e.year == year;
      });
    } catch (_) {
      return null;
    }
  }
}

final salarySlipRepositoryProvider = Provider<SalarySlipRepository>((ref) {
  return InMemorySalarySlipRepository();
});
