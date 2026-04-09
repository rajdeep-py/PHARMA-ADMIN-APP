import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/doctor.dart';

abstract class DoctorRepository {
	Future<List<Doctor>> list();

	Future<Doctor?> findById(String id);

	Future<void> upsert(Doctor doctor);

	Future<void> delete(String id);
}

class InMemoryDoctorRepository implements DoctorRepository {
	InMemoryDoctorRepository();

	final List<Doctor> _items = List<Doctor>.of(<Doctor>[
		Doctor(
			id: 'doc_1',
			name: 'Dr. Ananya Sen',
			specialization: 'Cardiologist',
			photoPath: 'assets/images/director.jpeg',
			addedByType: DoctorAddedByType.mr,
			addedById: 'mr_1',
			addedByName: 'Rahul Sharma',
			description:
					'Experienced cardiologist focused on preventive cardiology, hypertension management, and lifestyle interventions.',
			degrees: const ['MBBS', 'MD (Cardiology)'],
			experience: const [
				'8+ years clinical practice',
				'Visiting consultant at City Heart Clinic',
			],
			chambers: const [
				DoctorChamber(
					name: 'City Heart Clinic',
					phoneNumber: '+91 98765 12345',
					address: 'Sector V, Salt Lake, Kolkata',
				),
				DoctorChamber(
					name: 'Greenleaf Hospital OPD',
					phoneNumber: '+91 91234 56789',
					address: 'New Town, Kolkata',
				),
			],
			phoneNumber: '+91 98765 12345',
			email: 'dr.ananya.sen@example.com',
			address: 'Kolkata, West Bengal',
		),
		Doctor(
			id: 'doc_2',
			name: 'Dr. Rakesh Iyer',
			specialization: 'Dermatologist',
			photoPath: '',
			addedByType: DoctorAddedByType.asm,
			addedById: 'asm_2',
			addedByName: 'Priya Nair',
			description:
					'Dermatology specialist with interest in acne management, pigmentary disorders, and clinical cosmetology.',
			degrees: const ['MBBS', 'MD (Dermatology)'],
			experience: const [
				'10+ years practice',
				'Affiliated with SkinCare Centre',
			],
			chambers: const [
				DoctorChamber(
					name: 'SkinCare Centre',
					phoneNumber: '+91 90000 22221',
					address: 'Andheri West, Mumbai',
				),
			],
			phoneNumber: '+91 90000 22221',
			email: 'dr.rakesh.iyer@example.com',
			address: 'Mumbai, Maharashtra',
		),
	], growable: true);

	@override
	Future<List<Doctor>> list() async {
		await Future<void>.delayed(const Duration(milliseconds: 220));
		final items = [..._items]
			..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
		return List<Doctor>.unmodifiable(items);
	}

	@override
	Future<Doctor?> findById(String id) async {
		await Future<void>.delayed(const Duration(milliseconds: 120));
		try {
			return _items.firstWhere((e) => e.id == id);
		} catch (_) {
			return null;
		}
	}

	@override
	Future<void> upsert(Doctor doctor) async {
		await Future<void>.delayed(const Duration(milliseconds: 180));
		final index = _items.indexWhere((e) => e.id == doctor.id);
		if (index >= 0) {
			_items[index] = doctor;
		} else {
			_items.insert(0, doctor);
		}
	}

	@override
	Future<void> delete(String id) async {
		await Future<void>.delayed(const Duration(milliseconds: 150));
		_items.removeWhere((e) => e.id == id);
	}
}

final doctorRepositoryProvider = Provider<DoctorRepository>((ref) {
	return InMemoryDoctorRepository();
});
