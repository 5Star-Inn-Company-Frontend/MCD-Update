class AuthResultEntity {
  final bool success;
  final String? message;
  final String? token;
  final String? balance;
  final bool requires2FA;

  AuthResultEntity({
    required this.success,
    this.message,
    this.token,
    this.balance,
    this.requires2FA = false,
  });
}
