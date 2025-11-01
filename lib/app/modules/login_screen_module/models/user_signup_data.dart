class UserSignupData {
  final String username;
  final String email;
  final String phone;
  final String password;
  final String referral;
  final String code;
  final String version;

  UserSignupData({
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    this.referral = "",
    this.code = "",
    this.version = "1.0.0",
  });

  Map<String, dynamic> toJsonWithOtp(String otp) {
    return {
      "user_name": username,
      "password": password,
      "phoneno": phone,
      "email": email,
      "referral": referral,
      "code": otp,
      "version": version,
    };
  }

  @override
  String toString() {
    return 'UserSignupData(username: $username, email: $email, phone: $phone, password: $password, referral: $referral, code: $code, version: $version)';
  }
}
