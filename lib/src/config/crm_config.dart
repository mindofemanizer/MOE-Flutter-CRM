import 'package:equatable/equatable.dart';

/// Configuration for MOE CRM module.
class MoeCrmConfig extends Equatable {
  final String apiUrl;
  final bool enableLeadScoring;

  const MoeCrmConfig({
    required this.apiUrl,
    this.enableLeadScoring = true,
  });

  @override
  List<Object?> get props => [apiUrl, enableLeadScoring];
}
