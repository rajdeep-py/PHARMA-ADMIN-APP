import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mr_management.dart';

abstract class AsmManagementRepository {
	Future<List<MrManagement>> list();
	Future<void> upsert(MrManagement asm);
	Future<void> delete(String id);
}

class InMemoryAsmManagementRepository implements AsmManagementRepository {
	InMemoryAsmManagementRepository();

	final List<MrManagement> _items = [
		const MrManagement(
			id: 'asm_1',
			name: 'Amit Singh',
			password: 'asm@1234',
			phoneNumber: '+91 91000 11111',
			alternativePhoneNumber: '+91 91000 11112',
			email: 'amit.singh@example.com',
			address: '22, FC Road, Pune',
			headquarter: 'Pune HQ',
			territories: ['Shivaji Nagar', 'Kothrud', 'Hinjewadi'],
			bankName: 'ICICI Bank',
			bankAccountNumber: '9988776655',
			ifscCode: 'ICIC0000123',
			upiId: 'amit@upi',
			branchName: 'FC Road',
			photoBytes: null,
		),
		const MrManagement(
			id: 'asm_2',
			name: 'Priya Nair',
			password: 'asm@1234',
			phoneNumber: '+91 91000 22222',
			alternativePhoneNumber: null,
			email: 'priya.nair@example.com',
			address: '9, Indiranagar, Bengaluru',
			headquarter: 'Bengaluru HQ',
			territories: ['Indiranagar', 'Koramangala'],
			bankName: 'Axis Bank',
			bankAccountNumber: '2233445566',
			ifscCode: 'UTIB0000456',
			upiId: 'priya@upi',
			branchName: 'Indiranagar',
			photoBytes: null,
		),
	];

	@override
	Future<List<MrManagement>> list() async {
		await Future<void>.delayed(const Duration(milliseconds: 250));
		return List<MrManagement>.unmodifiable(_items);
	}

	@override
	Future<void> upsert(MrManagement asm) async {
		await Future<void>.delayed(const Duration(milliseconds: 180));
		final index = _items.indexWhere((e) => e.id == asm.id);
		if (index >= 0) {
			_items[index] = asm;
		} else {
			_items.insert(0, asm);
		}
	}

	@override
	Future<void> delete(String id) async {
		await Future<void>.delayed(const Duration(milliseconds: 150));
		_items.removeWhere((e) => e.id == id);
	}
}

final asmManagementRepositoryProvider = Provider<AsmManagementRepository>((ref) {
	return InMemoryAsmManagementRepository();
});

