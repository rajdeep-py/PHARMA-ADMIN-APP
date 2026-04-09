import 'dart:typed_data';

enum DistributorAddedByType { mr, asm }

extension DistributorAddedByTypeX on DistributorAddedByType {
	String get label {
		switch (this) {
			case DistributorAddedByType.mr:
				return 'MR';
			case DistributorAddedByType.asm:
				return 'ASM';
		}
	}
}

class Distributor {
	const Distributor({
		required this.id,
		required this.name,
		required this.address,
		required this.photoPath,
		this.photoBytes,
		required this.addedByType,
		required this.addedById,
		required this.addedByName,
		required this.description,
		required this.minimumOrderValue,
		required this.expectedDeliveryTime,
		required this.productsAvailable,
		required this.phoneNumber,
		required this.email,
	});

	final String id;

	final String name;
	final String address;

	/// Can be an asset path (e.g. `assets/...`) or a network URL.
	final String photoPath;

	/// Used when the admin picks a local photo (camera/gallery/files).
	final Uint8List? photoBytes;

	final DistributorAddedByType addedByType;
	final String addedById;
	final String addedByName;

	final String description;
	final double minimumOrderValue;
	final String expectedDeliveryTime;
	final List<String> productsAvailable;

	final String phoneNumber;
	final String email;

	Distributor copyWith({
		String? id,
		String? name,
		String? address,
		String? photoPath,
		Uint8List? photoBytes,
		DistributorAddedByType? addedByType,
		String? addedById,
		String? addedByName,
		String? description,
		double? minimumOrderValue,
		String? expectedDeliveryTime,
		List<String>? productsAvailable,
		String? phoneNumber,
		String? email,
	}) {
		return Distributor(
			id: id ?? this.id,
			name: name ?? this.name,
			address: address ?? this.address,
			photoPath: photoPath ?? this.photoPath,
			photoBytes: photoBytes ?? this.photoBytes,
			addedByType: addedByType ?? this.addedByType,
			addedById: addedById ?? this.addedById,
			addedByName: addedByName ?? this.addedByName,
			description: description ?? this.description,
			minimumOrderValue: minimumOrderValue ?? this.minimumOrderValue,
			expectedDeliveryTime: expectedDeliveryTime ?? this.expectedDeliveryTime,
			productsAvailable: productsAvailable ?? this.productsAvailable,
			phoneNumber: phoneNumber ?? this.phoneNumber,
			email: email ?? this.email,
		);
	}
}

