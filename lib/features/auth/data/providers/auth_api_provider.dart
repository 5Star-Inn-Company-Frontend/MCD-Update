// implementing endpoints: login, register, sendOtp, verifyOtp, resendOtp, forgotPassword
// handling encryption before sending and after receiving data

// import 'dart:convert';
import 'package:get/get.dart';
import 'package:mcd/core/network/api_service.dart';

class AuthApiProvider extends ApiService {

   Future<Response> sendCode(String encryptedBody) {
    return post("/sendcode", encryptedBody, headers: {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
    });
  }

  Future<Response> signup(String encryptedBody) {
    return post("/signup", encryptedBody, headers: {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
    });
  }

  Future<Response> login(String encryptedBody) async {
    return post("/login", encryptedBody, headers: {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
    });
  }

  // Future<Response> emailVerification(String email) async {
  //   dev.log('[AuthProvider] Sending email verification for: $email');
  //   final body = _encryptPayload({"email": email});
  //   return post("/email-verification", body);
  // }

  // Future<Response> emailVerificationContinue(String email, String code) async {
  //   dev.log('[AuthProvider] Verifying email code for: $email');
  //   final body = _encryptPayload({
  //     "email": email,
  //     "code": code
  //   });
  //   return post("/email-verification-continue", body);
  // }

  // Future<Response> newDevice(String username, String code) async {
  //   dev.log('Registering new device for user: $username');
  //   final body = _encryptPayload({
  //     "user_name": username,
  //     "code": code,
  //   });
  //   return post("/newdevice", body);
  // }

  // Future<Response> pinAuth(String username, String pin) async {
  //   dev.log('Attempting PIN authentication for user: $username');
  //   final body = _encryptPayload({
  //     "user_name": username,
  //     "pin": pin,
  //   });
  //   return post("/pinauth", body);
  // }

  // Future<Response> socialLogin(String email, String name, String avatar, String accesstoken, String source) async {
  //   dev.log('Processing social login for: $email, source: $source');
  //   final body = _encryptPayload({
  //     "email": email,
  //     "name": name,
  //     "avatar": avatar,
  //     "accesstoken": accesstoken,
  //     "source": source,
  //   });
  //   return post("/sociallogin", body);
  // }

  // Future<Response> biometricLogin() async {
  //   dev.log('Attempting biometric login');
  //   return get("/biometriclogin");
  // }

}
