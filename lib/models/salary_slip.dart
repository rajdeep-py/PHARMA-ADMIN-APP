enum SalarySlipEmployeeType { mr, asm }

extension SalarySlipEmployeeTypeX on SalarySlipEmployeeType {
  String get label {
    switch (this) {
      case SalarySlipEmployeeType.mr:
        return 'MR';
      case SalarySlipEmployeeType.asm:
        return 'ASM';
    }
  }
}

class SalarySlip {
  const SalarySlip({
    required this.id,
    required this.employeeType,
    required this.employeeId,
    required this.month,
    required this.year,
    required this.filePath,
    required this.fileName,
    required this.uploadedAt,
  });

  final String id;

  final SalarySlipEmployeeType employeeType;
  final String employeeId;

  final int month;
  final int year;

  final String filePath;
  final String fileName;

  final DateTime uploadedAt;

  SalarySlip copyWith({
    String? id,
    SalarySlipEmployeeType? employeeType,
    String? employeeId,
    int? month,
    int? year,
    String? filePath,
    String? fileName,
    DateTime? uploadedAt,
  }) {
    return SalarySlip(
      id: id ?? this.id,
      employeeType: employeeType ?? this.employeeType,
      employeeId: employeeId ?? this.employeeId,
      month: month ?? this.month,
      year: year ?? this.year,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}
