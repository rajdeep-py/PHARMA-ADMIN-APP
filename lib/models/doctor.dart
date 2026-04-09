import 'dart:typed_data';

enum DoctorAddedByType {
	mr,
	asm;

	String get label {
		switch (this) {
			case DoctorAddedByType.mr:
				return 'MR';
			case DoctorAddedByType.asm:
				return 'ASM';
		}
	}
}

class DoctorChamber {
	const DoctorChamber({
		required this.name,
		required this.phoneNumber,
		required this.address,
	});

	final String name;
	final String phoneNumber;
	final String address;
}

class Doctor {
	const Doctor({
		required this.id,
		required this.name,
		required this.specialization,
		required this.photoPath,
		this.photoBytes,
		required this.addedByType,
		required this.addedById,
		required this.addedByName,
		required this.description,
		required this.degrees,
		required this.experience,
		required this.chambers,
		required this.phoneNumber,
		required this.email,
		required this.address,
	});

	final String id;
	final String name;
	final String specialization;

	/// Either an asset path, a network URL, or empty.
	final String photoPath;
	final Uint8List? photoBytes;

	final DoctorAddedByType addedByType;
	final String addedById;
	final String addedByName;

	final String description;
	final List<String> degrees;
	final List<String> experience;
	final List<DoctorChamber> chambers;

	final String phoneNumber;
	final String email;
	final String address;
}
