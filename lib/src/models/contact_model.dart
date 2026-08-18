import 'package:equatable/equatable.dart';

/// Customer segment type.
enum CustomerSegment {
  individual('individual', 'Individu'),
  business('business', 'Bisnis');

  const CustomerSegment(this.code, this.displayName);
  final String code;
  final String displayName;

  factory CustomerSegment.fromValue(String value) {
    return values.firstWhere(
      (e) => e.code == value,
      orElse: () => individual,
    );
  }
}

/// Contact model with interaction history.
class ContactModel extends Equatable {
  final String id;
  final String firstName;
  final String? lastName;
  final String email;
  final String phone;
  final CustomerSegment segment;
  final String? company;
  final String? jobTitle;
  final String? notes;
  final int leadScore;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ContactModel({
    required this.id,
    required this.firstName,
    this.lastName,
    required this.email,
    required this.phone,
    required this.segment,
    this.company,
    this.jobTitle,
    this.notes,
    this.leadScore = 0,
    required this.createdAt,
    required this.updatedAt,
  }) : assert(email != ''),
       assert(phone != '');

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String?,
      email: json['email'] as String,
      phone: json['phone'] as String,
      segment: CustomerSegment.fromValue(json['segment']),
      company: json['company'] as String?,
      jobTitle: json['job_title'] as String?,
      notes: json['notes'] as String?,
      leadScore: json['lead_score'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      'email': email,
      'phone': phone,
      'segment': segment.code,
      if (company != null) 'company': company,
      if (jobTitle != null) 'job_title': jobTitle,
      if (notes != null) 'notes': notes,
      'lead_score': leadScore,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Full name with space separator.
  String get fullName => '$firstName${lastName != null ? ' $lastName' : ''}';

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        segment,
        company,
        jobTitle,
        notes,
        leadScore,
        createdAt,
        updatedAt,
      ];
}
