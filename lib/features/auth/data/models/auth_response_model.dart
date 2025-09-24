class AuthResponseModel {
  final bool success;
  final String? message;
  final String? token;

  AuthResponseModel({
    required this.success,
    this.message,
    this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] == 1 || json['success'] == 2 || json['success'] == true,
      message: json['message'],
      token: json['token'],
    );
  }

  @override
  String toString() {
    return 'AuthResponseModel(success: $success, message: $message, token: $token)';
  }
}
