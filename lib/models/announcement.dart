import 'package:flutter/foundation.dart';

@immutable
class Announcement {
	const Announcement({
		required this.id,
		required this.headline,
		required this.description,
		required this.createdAt,
		required this.updatedAt,
	});

	final String id;
	final String headline;
	final String description;
	final DateTime createdAt;
	final DateTime updatedAt;

	Announcement copyWith({
		String? id,
		String? headline,
		String? description,
		DateTime? createdAt,
		DateTime? updatedAt,
	}) {
		return Announcement(
			id: id ?? this.id,
			headline: headline ?? this.headline,
			description: description ?? this.description,
			createdAt: createdAt ?? this.createdAt,
			updatedAt: updatedAt ?? this.updatedAt,
		);
	}
}

