/// Interaction type.
sealed class InteractionType {
  const InteractionType();
  
  String get stringValue;
  
  factory InteractionType.fromString(String value) {
    switch (value) {
      case 'call':
        return call;
      case 'email':
        return email;
      case 'meeting':
        return meeting;
      case 'whatsapp':
        return whatsapp;
      default:
        throw Exception('Unknown interaction type: $value');
    }
  }

  static const call = _InteractionTypeCall();
  static const email = _InteractionTypeEnumEmail();
  static const meeting = _InteractionTypeMeeting();
  static const whatsapp = _InteractionTypeWhatsapp();
}

class _InteractionTypeCall extends InteractionType {
  const _InteractionTypeCall();
  @override
  String get stringValue => 'call';
}

class _InteractionTypeEnumEmail extends InteractionType {
  const _InteractionTypeEnumEmail();
  @override
  String get stringValue => 'email';
}

class _InteractionTypeMeeting extends InteractionType {
  const _InteractionTypeMeeting();
  @override
  String get stringValue => 'meeting';
}

class _InteractionTypeWhatsapp extends InteractionType {
  const _InteractionTypeWhatsapp();
  @override
  String get stringValue => 'whatsapp';
}
