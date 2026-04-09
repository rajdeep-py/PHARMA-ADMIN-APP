import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/distributor.dart';

abstract class DistributorRepository {
	Future<List<Distributor>> list();

	Future<Distributor?> findById(String id);

	Future<void> upsert(Distributor distributor);

	Future<void> delete(String id);
}

class InMemoryDistributorRepository implements DistributorRepository {
	InMemoryDistributorRepository();

	final List<Distributor> _items = List<Distributor>.of(<Distributor>[
		const Distributor(
			id: 'dist_1',
			name: 'Apex Distributors',
			address: 'Salt Lake, Kolkata, West Bengal',
			photoPath: '',
			addedByType: DistributorAddedByType.mr,
			addedById: 'mr_1',
			addedByName: 'Rahul Sharma',
			description:
					'Primary distributor for Salt Lake territory. Handles quick dispatch for OTC and prescription ranges.',
			minimumOrderValue: 5000,
			expectedDeliveryTime: '24-48 hours',
			productsAvailable: ['Tablets', 'Syrups', 'Ointments'],
			phoneNumber: '+91 98765 11111',
			email: 'apex.distributors@example.com',
		),
		const Distributor(
			id: 'dist_2',
			name: 'Greenline Pharma Supply',
			address: 'Andheri West, Mumbai, Maharashtra',
			photoPath: 'assets/images/director.jpeg',
			addedByType: DistributorAddedByType.asm,
			addedById: 'asm_2',
			addedByName: 'Priya Nair',
			description:
					'Covers Andheri-Bandra belt with weekly stock rotation and priority delivery for critical SKUs.',
			minimumOrderValue: 8000,
			expectedDeliveryTime: 'Same day (city limits)',
			productsAvailable: ['Injectables', 'Tablets', 'Supplements'],
			phoneNumber: '+91 90000 22221',
			email: 'greenline.supply@example.com',
		),
		const Distributor(
			id: 'dist_3',
			name: 'CarePlus Distribution',
			address: 'Hinjewadi, Pune, Maharashtra',
			photoPath: '',
			addedByType: DistributorAddedByType.asm,
			addedById: 'asm_1',
			addedByName: 'Amit Singh',
			description:
					'Supports Pune HQ and nearby territories with multi-brand availability and scheduled dispatch.',
			minimumOrderValue: 6500,
			expectedDeliveryTime: '48 hours',
			productsAvailable: ['Antibiotics', 'Analgesics', 'Syrups'],
			phoneNumber: '+91 91234 56780',
			email: 'careplus@example.com',
		),
	], growable: true);

	@override
	Future<List<Distributor>> list() async {
		await Future<void>.delayed(const Duration(milliseconds: 220));
		final items = [..._items]
			..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
		return List<Distributor>.unmodifiable(items);
	}

	@override
	Future<Distributor?> findById(String id) async {
		await Future<void>.delayed(const Duration(milliseconds: 120));
		try {
			return _items.firstWhere((e) => e.id == id);
		} catch (_) {
			return null;
		}
	}

	@override
	Future<void> upsert(Distributor distributor) async {
		await Future<void>.delayed(const Duration(milliseconds: 180));
		final index = _items.indexWhere((e) => e.id == distributor.id);
		if (index >= 0) {
			_items[index] = distributor;
		} else {
			_items.insert(0, distributor);
		}
	}

	@override
	Future<void> delete(String id) async {
		await Future<void>.delayed(const Duration(milliseconds: 150));
		_items.removeWhere((e) => e.id == id);
	}
}

final distributorRepositoryProvider = Provider<DistributorRepository>((ref) {
	return InMemoryDistributorRepository();
});

