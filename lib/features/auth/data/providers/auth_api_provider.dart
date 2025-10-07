// implementing endpoints: login, register, sendOtp, verifyOtp, resendOtp, forgotPassword
// handling encryption before sending and after receiving data

// import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  Future<Response> pinAuth(String encryptedBody) async {
    return post("/pinauth", encryptedBody, headers: {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
    });
  }

  Future<Response> newDevice(String encryptedBody) async {
    return post("/newdevice", encryptedBody, headers: {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
    });
  }

  Future<Response> biometricLogin() {
    return get(
      "/biometriclogin",
      headers: {
        "Content-Type": "application/json",
        "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
        "Authorization": "Bearer ${GetStorage().read("token")}",
      },
    );
  }

  Future<Response> dashboard() {
    return get(
      "/dashboard",
      headers: {
        "Content-Type": "application/json",
        "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
        "Authorization": "Bearer ${GetStorage().read("token")}",
      },
    );
  }

  Future<Response> referrals() {
    final token = GetStorage().read("token");
    return get(
      "/referrals",
      headers: {
        "Authorization": "Bearer $token",
        "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
        "Content-Type": "application/json",
      },
    );
  }

  Future<Response> resetPassword(String encryptedBody) async {
    return post("/resetpassword", encryptedBody, headers: {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
    });
  }

  Future<Response> resetPasswordCheck(String encryptedBody) async {
    return post("/resetpassword-check", encryptedBody, headers: {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
    });
  }

  Future<Response> changeResetPassword(String encryptedBody) async {
    return put("/resetpassword", encryptedBody, headers: {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
    });
  }

  Future<Response> sendEmailVerifyCode(String encryptedBody) async {
    return post("/email-verification", encryptedBody, headers: {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
    });
  }

  Future<Response> emailVerifyConfirm(String encryptedBody) async {
    return post("/email-verification-continue", encryptedBody, headers: {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
    });
  }

  Future<Response> kycUpdate(String encryptedBody) async {
    return post("/kyc-update", encryptedBody, headers: {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
    });
  }

  Future<Response> kycCheck(String encryptedBody) async {
    return post("/bvn-check", encryptedBody, headers: {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
    });
  }

  Future<Response> kycValidate(String encryptedBody) async {
    return post("/bvn-validate", encryptedBody, headers: {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
    });
  }
}
