class RegisterChallenge {
  final String identifier;
  final DateTime expiresAt;
  final DateTime resendAvailableAt;
  final int remainingResends;
  final String? debugOtp;

  const RegisterChallenge({
    required this.identifier,
    required this.expiresAt,
    required this.resendAvailableAt,
    required this.remainingResends,
    this.debugOtp,
  });

  factory RegisterChallenge.fromJson(Map<String, dynamic> json) {
    return RegisterChallenge(
      identifier: json['identifier'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      resendAvailableAt: DateTime.parse(json['resendAvailableAt'] as String),
      remainingResends: (json['remainingResends'] as num?)?.toInt() ?? 0,
      debugOtp: json['debugOtp'] as String?,
    );
  }
}
