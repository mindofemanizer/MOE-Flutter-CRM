import 'package:equatable/equatable.dart';

/// Customer interaction record.
class InteractionModel extends Equatable {
  final String id;
  final String contactId;
  final String type;
  final String subject;
  final String? notes;
  final DateTime occurredAt;
  final DateTime createdAt;

  const InteractionModel({
    required this.id,
    required this.contactId,
    required this.type,
    required this.subject,
    this.notes,
    required this.occurredAt,
    required this.createdAt,
  });

  factory InteractionModel.fromJson(Map<String, dynamic> json) {
    return InteractionModel(
      id: json['id'] as String,
      contactId: json['contact_id'] as String,
      type: json['type'] as String,
      subject: json['subject'] as String,
      notes: json['notes'] as String?,
      occurredAt: DateTime.parse(json['occurred_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contact_id': contactId,
      'type': type,
      'subject': subject,
      if (notes != null) 'notes': notes,
      'occurred_at': occurredAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  InteractionType get interactionType => InteractionType.fromString(type);

  @override
  List<Object?> get props => [id, contactId, type, subject, notes, occurredAt, createdAt];
}
