import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moe_flutter_core/moe_flutter_core.dart';
import 'package:moe_flutter_crm/src/config/crm_config.dart';
import 'package:moe_flutter_crm/src/models/contact_model.dart';
import 'package:moe_flutter_crm/src/models/interaction_model.dart';

/// Repository for CRM operations.
class CrmRepository {
  final Dio _dio;
  final MoeCrmConfig _config;

  CrmRepository(this._dio, this._config);

  // ── Contacts ───────────────────────────────────────────────

  /// List contacts with filtering.
  Future<AppResult<List<ContactModel>>> listContacts({
    String? search,
    CustomerSegment? segment,
    DateTime? createdAfter,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final params = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
        if (segment != null) 'segment': segment.code,
        if (createdAfter != null) 'created_after': createdAfter.toIso8601String(),
      };
      final response = await _dio.get('/contacts', queryParameters: params);
      final data = response.data as Map<String, dynamic>;
      final contacts = (data['data'] as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map((c) => ContactModel.fromJson(c))
          .toList();
      return Ok(contacts);
    } on DioException catch (e) {
      return Err(mapDioErrorToFailure(e));
    } catch (e) {
      return Err(AppFailure(
        type: FailureType.unknown,
        message: e.toString(),
      ));
    }
  }

  /// Get single contact by ID.
  Future<AppResult<ContactModel>> getContact(String id) async {
    try {
      final response = await _dio.get('/contacts/$id');
      return Ok(ContactModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Err(mapDioErrorToFailure(e));
    } catch (e) {
      return Err(AppFailure(
        type: FailureType.unknown,
        message: e.toString(),
      ));
    }
  }

  /// Create new contact.
  Future<AppResult<ContactModel>> createContact({
    required String firstName,
    required String email,
    required String phone,
    CustomerSegment segment = CustomerSegment.individual,
    String? lastName,
    String? company,
    String? jobTitle,
    int leadScore = 0,
    String? notes,
  }) async {
    try {
      final response = await _dio.post('/contacts', data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'segment': segment.code,
        if (company != null) 'company': company,
        if (jobTitle != null) 'job_title': jobTitle,
        'lead_score': leadScore,
        if (notes != null) 'notes': notes,
      });
      return Ok(ContactModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Err(mapDioErrorToFailure(e));
    } catch (e) {
      return Err(AppFailure(
        type: FailureType.unknown,
        message: e.toString(),
      ));
    }
  }

  /// Update contact.
  Future<AppResult<void>> updateContact(String id, {
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? company,
    String? jobTitle,
    int? leadScore,
    String? notes,
  }) async {
    try {
      await _dio.patch('/contacts/$id', data: {
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (company != null) 'company': company,
        if (jobTitle != null) 'job_title': jobTitle,
        if (leadScore != null) 'lead_score': leadScore,
        if (notes != null) 'notes': notes,
      });
      return const Ok(null);
    } on DioException catch (e) {
      return Err(mapDioErrorToFailure(e));
    } catch (e) {
      return Err(AppFailure(
        type: FailureType.unknown,
        message: e.toString(),
      ));
    }
  }

  // ── Interactions ───────────────────────────────────────────

  /// Record interaction with contact.
  Future<AppResult<InteractionModel>> createInteraction({
    required String contactId,
    required String type,
    required String subject,
    String? notes,
    DateTime? occurredAt,
  }) async {
    try {
      final response = await _dio.post('/interactions', data: {
        'contact_id': contactId,
        'type': type,
        'subject': subject,
        if (notes != null) 'notes': notes,
        if (occurredAt != null) 'occurred_at': occurredAt.toIso8601String(),
      });
      return Ok(InteractionModel.fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Err(mapDioErrorToFailure(e));
    } catch (e) {
      return Err(AppFailure(
        type: FailureType.unknown,
        message: e.toString(),
      ));
    }
  }

  /// List interactions for contact.
  Future<AppResult<List<InteractionModel>>> listInteractions(String contactId) async {
    try {
      final response = await _dio.get('/contacts/$contactId/interactions');
      final data = response.data as List<dynamic>;
      final interactions = data
          .whereType<Map<String, dynamic>>()
          .map((i) => InteractionModel.fromJson(i))
          .toList();
      return Ok(interactions);
    } on DioException catch (e) {
      return Err(mapDioErrorToFailure(e));
    } catch (e) {
      return Err(AppFailure(
        type: FailureType.unknown,
        message: e.toString(),
      ));
    }
  }
}
