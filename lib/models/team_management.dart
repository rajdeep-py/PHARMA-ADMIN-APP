
import 'dart:typed_data';

enum TeamMemberRole { mr, asm }

class TeamMember {
	const TeamMember({
		required this.id,
		required this.name,
		required this.role,
		this.photoBytes,
		this.isLeader = false,
	});

	final String id;
	final String name;
	final TeamMemberRole role;
	final Uint8List? photoBytes;
	final bool isLeader;

	String get roleLabel {
		switch (role) {
			case TeamMemberRole.mr:
				return 'MR';
			case TeamMemberRole.asm:
				return 'ASM';
		}
	}

	TeamMember copyWith({
		String? id,
		String? name,
		TeamMemberRole? role,
		Uint8List? photoBytes,
		bool? isLeader,
	}) {
		return TeamMember(
			id: id ?? this.id,
			name: name ?? this.name,
			role: role ?? this.role,
			photoBytes: photoBytes ?? this.photoBytes,
			isLeader: isLeader ?? this.isLeader,
		);
	}
}

enum TeamMessageSenderType { admin, mr, asm }

enum TeamMessageAttachmentType { image, video, file, voice }

class TeamMessageAttachment {
	const TeamMessageAttachment({
		required this.type,
		required this.bytes,
		required this.fileName,
		this.mimeType,
		this.durationMs,
	});

	final TeamMessageAttachmentType type;
	final Uint8List bytes;
	final String fileName;
	final String? mimeType;
	final int? durationMs;
}

class TeamChatMessage {
	const TeamChatMessage({
		required this.id,
		required this.teamId,
		required this.sentAt,
		required this.senderType,
		required this.senderName,
		this.text,
		this.attachment,
	});

	final String id;
	final String teamId;
	final DateTime sentAt;
	final TeamMessageSenderType senderType;
	final String senderName;
	final String? text;
	final TeamMessageAttachment? attachment;
}

class TeamManagement {
	const TeamManagement({
		required this.id,
		required this.name,
		required this.description,
		required this.photoBytes,
		required this.members,
		required this.messages,
	});

	final String id;
	final String name;
	final String description;
	final Uint8List? photoBytes;
	final List<TeamMember> members;
	final List<TeamChatMessage> messages;

	int get memberCount => members.length;

	TeamMember? get leader {
		for (final m in members) {
			if (m.isLeader) return m;
		}
		return null;
	}

	TeamManagement copyWith({
		String? id,
		String? name,
		String? description,
		Uint8List? photoBytes,
		List<TeamMember>? members,
		List<TeamChatMessage>? messages,
	}) {
		return TeamManagement(
			id: id ?? this.id,
			name: name ?? this.name,
			description: description ?? this.description,
			photoBytes: photoBytes ?? this.photoBytes,
			members: members ?? this.members,
			messages: messages ?? this.messages,
		);
	}
}

