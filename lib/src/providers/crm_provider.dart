import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moe_flutter_core/moe_flutter_core.dart';
import 'package:moe_flutter_crm/src/config/crm_config.dart';
import 'package:moe_flutter_crm/src/models/contact_model.dart';
import 'package:moe_flutter_crm/src/services/crm_repository.dart';

/// State for contacts.
sealed class ContactsState {
  const ContactsState();
}

final class ContactsInitial extends ContactsState {}

final class ContactsLoading extends ContactsState {}

final class ContactsLoaded extends ContactsState {
  final List<ContactModel> contacts;
  const ContactsLoaded(this.contacts);
}

final class ContactError extends ContactsState {
  final AppFailure failure;
  const ContactError(this.failure);
}

/// Notifier for contacts.
class ContactsNotifier extends StateNotifier<ContactsState> {
  final CrmRepository _repository;

  ContactsNotifier(this._repository) : super(const ContactsInitial());

  Future<void> loadContacts({
    String? search,
    CustomerSegment? segment,
  }) async {
    state = const ContactsLoading();

    final result = await _repository.listContacts(
      search: search,
      segment: segment,
    );

    switch (result) {
      case Ok(:final data):
        state = ContactsLoaded(data);
      case Err(:final failure):
        state = ContactError(failure);
    }
  }

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
    final result = await _repository.createContact(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      segment: segment,
      company: company,
      jobTitle: jobTitle,
      leadScore: leadScore,
      notes: notes,
    );

    if (result is Ok && state is ContactsLoaded) {
      final loaded = state as ContactsLoaded;
      // Add to beginning (newest first)
      state = ContactsLoaded([result.data, ...loaded.contacts]);
    }

    return result;
  }
}

/// Provider for CrmRepository.
final crmRepositoryProvider = Provider<CrmRepository>((ref) {
  throw UnimplementedError('MoeCrm.setup() must be called before use.');
});

/// Provider for ContactsNotifier.
final contactsProvider = StateNotifierProviderFactory<ContactsNotifier>(
  (ref) => ContactsNotifier(ref.watch(crmRepositoryProvider)),
);
