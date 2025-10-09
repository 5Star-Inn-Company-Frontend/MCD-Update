import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
// import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/utils/aes_helper.dart';
import 'package:mcd/features/auth/data/models/auth_response_model.dart';
import 'package:mcd/features/auth/data/providers/auth_api_provider.dart';
import 'package:mcd/features/auth/domain/entities/auth_result_entity.dart';
import 'package:mcd/features/auth/domain/entities/user_signup_data.dart';
import 'package:mcd/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:mcd/core/network/errors.dart';
import 'package:mcd/features/home/data/model/dashboard_model.dart';
import 'package:mcd/features/home/data/model/referral_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiProvider apiProvider;
  final AESHelper aesHelper;
  final box = GetStorage();

  AuthRepositoryImpl(this.apiProvider, this.aesHelper);

  String _stripPhpSerialized(String decrypted) {
    final regex = RegExp(r's:\d+:"(.*)";$', dotAll: true);
    final match = regex.firstMatch(decrypted);
    if (match != null) {
      return match.group(1)!; // inner JSON string
    }
    throw FormatException("Invalid serialized format");
  }

  @override
  Future<Either<Failure, bool>> sendCode(String email) async {
    try {
      // Step 1: Build PHP-style serialized body
      final jsonBody = jsonEncode({"email": email});
      final length = jsonBody.length;
      final phpSerialized = 's:$length:"$jsonBody";';

      // Step 2: Encrypt
      final iv = IV.fromSecureRandom(12);
      final encrypted = aesHelper.encryptText(phpSerialized, iv);

      // decrypt
      final decrypted = aesHelper.decryptText(encrypted, iv);
      dev.log("[DEBUG] Decrypted sendcode payload: $decrypted");

      // Step 3: Extract ciphertext + tag
      final encryptedBytes = encrypted.bytes;
      final cipherText = encryptedBytes.sublist(0, encryptedBytes.length - 16); // all except last 16
      final tag = encryptedBytes.sublist(encryptedBytes.length - 16); // last 16

      // Step 4: Build Laravel-compatible structure
      final body = {
        "iv": base64Encode(iv.bytes),
        "value": base64Encode(cipherText),
        "mac": "",
        "tag": base64Encode(tag),
      };

      final bodyBase64 = base64Encode(utf8.encode(jsonEncode(body)));

      // dev.log("IV: ${base64Encode(iv.bytes)}");
      // dev.log("CipherText: ${base64Encode(cipherText)}");
      // dev.log("Tag: ${base64Encode(tag)}");
      dev.log("Laravel Body JSON: $body");
      dev.log("Final Payload (Base64): $bodyBase64");

      // Step 5: Send request
      final response = await apiProvider.sendCode(bodyBase64);
      dev.log("Send code response: ${response.statusCode} => ${response.body}");
      // Get.snackbar("Message", "${response.body['message']}");

      if (response.isOk &&
          response.body != null &&
          response.body['success'] == 1) {
        return Right(true);
      } else {
        return Left(ServerFailure("Send code failed: ${response.statusText}"));
      }
    } catch (e) {
      dev.log("Send code error: $e");
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, AuthResultEntity>> signup(UserSignupData data, String otp) async {
    try {
      final payload = jsonEncode(data.toJsonWithOtp(otp));
      final length = payload.length;
      final phpSerialized = 's:$length:"$payload";';

      // encrypt the serialized payload 
      final iv = IV.fromSecureRandom(12);
      final encrypted = aesHelper.encryptText(phpSerialized, iv);

      // decrypt
      final decrypted = aesHelper.decryptText(encrypted, iv);
      dev.log("[DEBUG] Decrypted signup payload: $decrypted");

      final encryptedBytes = encrypted.bytes;
      final cipherText = encryptedBytes.sublist(0, encryptedBytes.length - 16);
      final tag = encryptedBytes.sublist(encryptedBytes.length - 16);

      final body = {
        "iv": base64Encode(iv.bytes),
        "value": base64Encode(cipherText),
        "mac": "",
        "tag": base64Encode(tag),
      };

      final bodyBase64 = base64Encode(utf8.encode(jsonEncode(body)));

      final response = await apiProvider.signup(bodyBase64);
      dev.log("Signup response: ${response.statusCode} => ${response.body}");

      if (response.isOk && response.body != null && response.body['success'] == 1) {
        final model = AuthResponseModel.fromJson(response.body);
        return Right(AuthResultEntity(success: model.success, message: model.message));
      } else {
        return Left(ServerFailure("Signup failed: ${response.statusText}"));
      }
    } catch (e) {
      dev.log("Signup error: $e");
      return Left(ServerFailure("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> login(String username, String password) async {
    try {
      final payload = jsonEncode({"user_name": username, "password": password});
      final length = payload.length;
      final phpSerialized = 's:$length:"$payload";';

      final iv = IV.fromSecureRandom(12);
      final encrypted = aesHelper.encryptText(phpSerialized, iv);

      final encryptedBytes = encrypted.bytes;
      final cipherText = encryptedBytes.sublist(0, encryptedBytes.length - 16);
      final tag = encryptedBytes.sublist(encryptedBytes.length - 16);

      final body = {
        "iv": base64Encode(iv.bytes),
        "value": base64Encode(cipherText),
        "mac": "",
        "tag": base64Encode(tag),
      };

      final bodyBase64 = base64Encode(utf8.encode(jsonEncode(body)));
      final response = await apiProvider.login(bodyBase64);

      dev.log("Login response: ${response.statusCode}");

      if (response.isOk && response.body != null) {
        final rawBody = response.bodyString!;
        // dev.log("Raw login body: $rawBody");

        // Step 1: Decode from base64
        final decodedJson = utf8.decode(base64Decode(rawBody));
        // dev.log("After base64 decode: $decodedJson");

        // Step 2: Parse JSON with iv, value, tag
        final Map<String, dynamic> encryptedMap = jsonDecode(decodedJson);

        // Step 3: Rebuild Encrypted object
        final cipherText = base64Decode(encryptedMap["value"]);
        final tag = base64Decode(encryptedMap["tag"]);
        final combined = Uint8List.fromList([...cipherText, ...tag]);

        final iv = IV.fromBase64(encryptedMap["iv"]);
        final encrypted = Encrypted(combined);

        // Step 4: Decrypt using AESHelper
        final decryptedString = aesHelper.decryptText(encrypted, iv);
        // dev.log("Decrypted response: $decryptedString");

        // Step 5: Strip PHP serialization
        final cleanJson = _stripPhpSerialized(decryptedString);
        dev.log("Clean JSON: $cleanJson");

        // Step 6: Parse actual API response
        final Map<String, dynamic> data = jsonDecode(cleanJson);
        return Right(data);
        } else {
          return Left(ServerFailure("Login failed: ${response.statusText}"));
        }
      } catch (e) {
        dev.log("Login error: $e");
        return Left(ServerFailure("Unexpected error: $e"));
      }
    }

  @override
  Future<void> logout() async {
    try {
      await box.remove('token'); // remove only token
    } catch (e) {
      dev.log("Logout error: $e");
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> pinAuth(String username, String pin) async {
    try {
      final payload = jsonEncode({"user_name": username, "pin": pin});
      final length = payload.length;
      final phpSerialized = 's:$length:"$payload";';

      final iv = IV.fromSecureRandom(12);
      final encrypted = aesHelper.encryptText(phpSerialized, iv);

      final encryptedBytes = encrypted.bytes;
      final cipherText = encryptedBytes.sublist(0, encryptedBytes.length - 16);
      final tag = encryptedBytes.sublist(encryptedBytes.length - 16);

      final body = {
        "iv": base64Encode(iv.bytes),
        "value": base64Encode(cipherText),
        "mac": "",
        "tag": base64Encode(tag),
      };

      final bodyBase64 = base64Encode(utf8.encode(jsonEncode(body)));
      final response = await apiProvider.pinAuth(bodyBase64);

      dev.log("PinAuth response: ${response.statusCode} => ${response.body}");

      if (response.isOk && response.body != null) {
        // return Right(Map<String, dynamic>.from(response.body));
        final decodedJson = utf8.decode(base64Decode(response.body));
        final Map<String, dynamic> data = jsonDecode(decodedJson);
        return Right(data);
      } else {
        return Left(ServerFailure("PinAuth failed: ${response.statusText}"));
      }
    } catch (e) {
      dev.log("PinAuth error: $e");
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyNewDevice(String username, String code) async {
    try {
      final payload = jsonEncode({"user_name": username, "code": code});
      final length = payload.length;
      final phpSerialized = 's:$length:"$payload";';

      final iv = IV.fromSecureRandom(12);
      final encrypted = aesHelper.encryptText(phpSerialized, iv);

      final encryptedBytes = encrypted.bytes;
      final cipherText = encryptedBytes.sublist(0, encryptedBytes.length - 16);
      final tag = encryptedBytes.sublist(encryptedBytes.length - 16);

      final body = {
        "iv": base64Encode(iv.bytes),
        "value": base64Encode(cipherText),
        "mac": "",
        "tag": base64Encode(tag),
      };

      final bodyBase64 = base64Encode(utf8.encode(jsonEncode(body)));
      final response = await apiProvider.newDevice(bodyBase64);

      dev.log("NewDevice response: ${response.statusCode} => ${response.body}");

      if (response.isOk && response.body != null) {
        // return Right(Map<String, dynamic>.from(response.body));
        final decodedJson = utf8.decode(base64Decode(response.body));
        final Map<String, dynamic> data = jsonDecode(decodedJson);
        return Right(data);
      } else {
        return Left(ServerFailure("NewDevice failed: ${response.statusText}"));
      }
    } catch (e) {
      dev.log("NewDevice error: $e");
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> biometricLogin() async {
    try {
      final response = await apiProvider.biometricLogin();
      dev.log("Biometric Login response: ${response.statusCode}");

      if (!response.isOk || response.bodyString == null) {
        return Left(ServerFailure("Biometric Login request failed: ${response.statusText}"));
      }

      final rawBody = response.bodyString!;

      final decodedJson = utf8.decode(base64Decode(rawBody));
      
      final Map<String, dynamic> encryptedMap = jsonDecode(decodedJson);

      final cipherText = base64Decode(encryptedMap["value"]);
      final tag = base64Decode(encryptedMap["tag"]);
      final combined = Uint8List.fromList([...cipherText, ...tag]);

      final iv = IV.fromBase64(encryptedMap["iv"]);
      final encrypted = Encrypted(combined);

      final decryptedString = aesHelper.decryptText(encrypted, iv);
      
      final cleanJson = _stripPhpSerialized(decryptedString);
      dev.log("Biometric Login Clean JSON: $cleanJson");

      final Map<String, dynamic> data = jsonDecode(cleanJson);
      // final biometricLoginData = DashboardModel.fromJson(data);

      return Right(data);
    } catch (e) {
      dev.log("Biometric Login error: $e");
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> socialLogin(String email, String name, String avatar, String accesstoken, String source) async {
    try {
      final payload = jsonEncode({"email": email, "name": name, 'avatar': avatar, 'accesstoken': accesstoken, 'source': source});
      final length = payload.length;
      final phpSerialized = 's:$length:"$payload";';

      final iv = IV.fromSecureRandom(12);
      final encrypted = aesHelper.encryptText(phpSerialized, iv);

      final encryptedBytes = encrypted.bytes;
      final cipherText = encryptedBytes.sublist(0, encryptedBytes.length - 16);
      final tag = encryptedBytes.sublist(encryptedBytes.length - 16);

      final body = {
        "iv": base64Encode(iv.bytes),
        "value": base64Encode(cipherText),
        "mac": "",
        "tag": base64Encode(tag),
      };

      final bodyBase64 = base64Encode(utf8.encode(jsonEncode(body)));
      final response = await apiProvider.socialLogin(bodyBase64);

      dev.log("Social Login response: ${response.statusCode}");

      if (response.isOk && response.body != null) {
        final rawBody = response.bodyString!;

        final decodedJson = utf8.decode(base64Decode(rawBody));

        final Map<String, dynamic> encryptedMap = jsonDecode(decodedJson);

        final cipherText = base64Decode(encryptedMap["value"]);
        final tag = base64Decode(encryptedMap["tag"]);
        final combined = Uint8List.fromList([...cipherText, ...tag]);

        final iv = IV.fromBase64(encryptedMap["iv"]);
        final encrypted = Encrypted(combined);

        final decryptedString = aesHelper.decryptText(encrypted, iv);

        final cleanJson = _stripPhpSerialized(decryptedString);
        dev.log("Social Login Clean JSON: $cleanJson");

        final Map<String, dynamic> data = jsonDecode(cleanJson);
        return Right(data);
        } else {
          return Left(ServerFailure("Social Login failed: ${response.statusText}"));
        }
      } catch (e) {
        dev.log("Social Login error: $e");
        return Left(ServerFailure("Unexpected error: $e"));
      }
    }

  @override
  Future<Either<Failure, DashboardModel>> dashboard() async {
    try {
      // Call provider
      final response = await apiProvider.dashboard();
      dev.log("Dashboard response: ${response.statusCode}");

      if (!response.isOk || response.bodyString == null) {
        return Left(ServerFailure("Dashboard request failed: ${response.statusText}"));
      }

      final rawBody = response.bodyString!;
      // dev.log("Raw dashboard body: $rawBody");

      // Step 1: Base64 decode
      final decodedJson = utf8.decode(base64Decode(rawBody));
      // dev.log("After base64 decode: $decodedJson");

      // Step 2: Parse encrypted map
      final Map<String, dynamic> encryptedMap = jsonDecode(decodedJson);

      // Step 3: Extract cipher + tag
      final cipherText = base64Decode(encryptedMap["value"]);
      final tag = base64Decode(encryptedMap["tag"]);
      final combined = Uint8List.fromList([...cipherText, ...tag]);

      final iv = IV.fromBase64(encryptedMap["iv"]);
      final encrypted = Encrypted(combined);

      // Step 4: Decrypt
      final decryptedString = aesHelper.decryptText(encrypted, iv);
      // dev.log("Decrypted response: $decryptedString");

      // Step 5: Strip PHP serialized wrapper
      final cleanJson = _stripPhpSerialized(decryptedString);
      dev.log("Clean JSON: $cleanJson");

      // Step 6: Parse final model
      final Map<String, dynamic> data = jsonDecode(cleanJson);
      final dashboard = DashboardModel.fromJson(data);

      return Right(dashboard);
    } catch (e) {
      dev.log("Dashboard error: $e");
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, List<ReferralModel>>> referrals() async {
    try {
      // Call provider
      final response = await apiProvider.referrals();
      dev.log("Referrals response: ${response.statusCode}");

      if (!response.isOk || response.bodyString == null) {
        return Left(ServerFailure("Referrals request failed: ${response.statusText}"));
      }

      final rawBody = response.bodyString!;
      // dev.log("Raw referrals body: $rawBody");

      // Step 1: Base64 decode
      final decodedJson = utf8.decode(base64Decode(rawBody));
      // dev.log("After base64 decode: $decodedJson");

      // Step 2: Parse encrypted map
      final Map<String, dynamic> encryptedMap = jsonDecode(decodedJson);

      // Step 3: Extract cipher + tag
      final cipherText = base64Decode(encryptedMap["value"]);
      final tag = base64Decode(encryptedMap["tag"]);
      final combined = Uint8List.fromList([...cipherText, ...tag]);

      final iv = IV.fromBase64(encryptedMap["iv"]);
      final encrypted = Encrypted(combined);

      // Step 4: Decrypt
      final decryptedString = aesHelper.decryptText(encrypted, iv);
      // dev.log("Decrypted referrals response: $decryptedString");

      // Step 5: Strip PHP serialized wrapper
      final cleanJson = _stripPhpSerialized(decryptedString);
      dev.log("Clean referrals JSON: $cleanJson");

      // Step 6: Parse final model list
      final Map<String, dynamic> data = jsonDecode(cleanJson);

      if (data['success'] == 1) {
        final List<dynamic> list = data['data'] ?? [];
        final referrals = list.map((e) => ReferralModel.fromJson(e)).toList();
        return Right(referrals);
      } else {
        return Left(ServerFailure(data['message'] ?? "Failed to fetch referrals"));
      }
    } catch (e) {
      dev.log("Referrals error: $e");
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> resetPassword(String email) async {
    try {
      final jsonBody = jsonEncode({"email": email});
      final length = jsonBody.length;
      final phpSerialized = 's:$length:"$jsonBody";';

      final iv = IV.fromSecureRandom(12);
      final encrypted = aesHelper.encryptText(phpSerialized, iv);

      final decrypted = aesHelper.decryptText(encrypted, iv);
      dev.log("[DEBUG] Decrypted resetpassword code payload: $decrypted");

      final encryptedBytes = encrypted.bytes;
      final cipherText = encryptedBytes.sublist(0, encryptedBytes.length - 16); // all except last 16
      final tag = encryptedBytes.sublist(encryptedBytes.length - 16); // last 16

      final body = {
        "iv": base64Encode(iv.bytes),
        "value": base64Encode(cipherText),
        "mac": "",
        "tag": base64Encode(tag),
      };

      final bodyBase64 = base64Encode(utf8.encode(jsonEncode(body)));
      final response = await apiProvider.resetPassword(bodyBase64);

      dev.log("Send forgot password code response: ${response.statusCode}");
      // Get.snackbar("Message", "${response.body['message']}");

      if (response.isOk && response.body != null) {
         final rawBody = response.bodyString!;
        // dev.log("Raw login body: $rawBody");

        final decodedJson = utf8.decode(base64Decode(rawBody));
        // dev.log("After base64 decode: $decodedJson");

        final Map<String, dynamic> encryptedMap = jsonDecode(decodedJson);

        final cipherText = base64Decode(encryptedMap["value"]);
        final tag = base64Decode(encryptedMap["tag"]);
        final combined = Uint8List.fromList([...cipherText, ...tag]);

        final iv = IV.fromBase64(encryptedMap["iv"]);
        final encrypted = Encrypted(combined);

        final decryptedString = aesHelper.decryptText(encrypted, iv);

        final cleanJson = _stripPhpSerialized(decryptedString);
        dev.log("Clean JSON: $cleanJson");

        final Map<String, dynamic> data = jsonDecode(cleanJson);
        return Right(data);
      } else {
        return Left(ServerFailure("Send code failed: ${response.statusText}"));
      }
    } catch (e) {
      dev.log("Send code error: $e");
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }
  
  @override
  Future<Either<Failure, Map<String, dynamic>>> resetPasswordCheck(String email, String code) async {
    try {
      final jsonBody = jsonEncode({"email": email, "code": code});
      final length = jsonBody.length;
      final phpSerialized = 's:$length:"$jsonBody";';

      final iv = IV.fromSecureRandom(12);
      final encrypted = aesHelper.encryptText(phpSerialized, iv);

      final decrypted = aesHelper.decryptText(encrypted, iv);
      dev.log("[DEBUG] Decrypted resetpassword check payload: $decrypted");

      final encryptedBytes = encrypted.bytes;
      final cipherText = encryptedBytes.sublist(0, encryptedBytes.length - 16); // all except last 16
      final tag = encryptedBytes.sublist(encryptedBytes.length - 16); // last 16

      final body = {
        "iv": base64Encode(iv.bytes),
        "value": base64Encode(cipherText),
        "mac": "",
        "tag": base64Encode(tag),
      };

      final bodyBase64 = base64Encode(utf8.encode(jsonEncode(body)));
      final response = await apiProvider.resetPasswordCheck(bodyBase64);

      dev.log("Forgot password-check response: ${response.statusCode}");

      if (response.isOk && response.body != null) {
        final rawBody = response.bodyString!;

        final decodedJson = utf8.decode(base64Decode(rawBody));

        final Map<String, dynamic> encryptedMap = jsonDecode(decodedJson);

        final cipherText = base64Decode(encryptedMap["value"]);
        final tag = base64Decode(encryptedMap["tag"]);
        final combined = Uint8List.fromList([...cipherText, ...tag]);

        final iv = IV.fromBase64(encryptedMap["iv"]);
        final encrypted = Encrypted(combined);

        final decryptedString = aesHelper.decryptText(encrypted, iv);

        final cleanJson = _stripPhpSerialized(decryptedString);
        dev.log("Clean JSON: $cleanJson");

        final Map<String, dynamic> data = jsonDecode(cleanJson);
        return Right(data);
      } else {
        return Left(ServerFailure("Reset Password check failed: ${response.statusText}"));
      }
    } catch (e) {
      dev.log("Reset Password check: $e");
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> changeResetPassword(String email, String code, String password) async {
    try {
      final jsonBody = jsonEncode({"email": email, "code": code, "password": password});
      final length = jsonBody.length;
      final phpSerialized = 's:$length:"$jsonBody";';

      final iv = IV.fromSecureRandom(12);
      final encrypted = aesHelper.encryptText(phpSerialized, iv);

      final decrypted = aesHelper.decryptText(encrypted, iv);
      dev.log("[DEBUG] Decrypted change-reset-password payload: $decrypted");

      final encryptedBytes = encrypted.bytes;
      final cipherText = encryptedBytes.sublist(0, encryptedBytes.length - 16); // all except last 16
      final tag = encryptedBytes.sublist(encryptedBytes.length - 16); // last 16

      final body = {
        "iv": base64Encode(iv.bytes),
        "value": base64Encode(cipherText),
        "mac": "",
        "tag": base64Encode(tag),
      };

      final bodyBase64 = base64Encode(utf8.encode(jsonEncode(body)));
      final response = await apiProvider.changeResetPassword(bodyBase64);

      dev.log("Change-reset-password response: ${response.statusCode}");

      if (response.isOk && response.body != null) {
        final rawBody = response.bodyString!;

        final decodedJson = utf8.decode(base64Decode(rawBody));

        final Map<String, dynamic> encryptedMap = jsonDecode(decodedJson);

        final cipherText = base64Decode(encryptedMap["value"]);
        final tag = base64Decode(encryptedMap["tag"]);
        final combined = Uint8List.fromList([...cipherText, ...tag]);

        final iv = IV.fromBase64(encryptedMap["iv"]);
        final encrypted = Encrypted(combined);

        final decryptedString = aesHelper.decryptText(encrypted, iv);

        final cleanJson = _stripPhpSerialized(decryptedString);
        dev.log("Clean JSON: $cleanJson");

        final Map<String, dynamic> data = jsonDecode(cleanJson);
        return Right(data);
      } else {
        return Left(ServerFailure("Change Password failed: ${response.statusText}"));
      }
    } catch (e) {
      dev.log("Change Reset Password: $e");
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendEmailVerifyCode(String email) async {
    try {
      final jsonBody = jsonEncode({"email": email});
      final length = jsonBody.length;
      final phpSerialized = 's:$length:"$jsonBody";';

      final iv = IV.fromSecureRandom(12);
      final encrypted = aesHelper.encryptText(phpSerialized, iv);

      final decrypted = aesHelper.decryptText(encrypted, iv);
      dev.log("[DEBUG] Decrypted email verify code payload: $decrypted");

      final encryptedBytes = encrypted.bytes;
      final cipherText = encryptedBytes.sublist(0, encryptedBytes.length - 16);
      final tag = encryptedBytes.sublist(encryptedBytes.length - 16);

      final body = {
        "iv": base64Encode(iv.bytes),
        "value": base64Encode(cipherText),
        "mac": "",
        "tag": base64Encode(tag),
      };

      final bodyBase64 = base64Encode(utf8.encode(jsonEncode(body)));
      final response = await apiProvider.sendEmailVerifyCode(bodyBase64);

      dev.log("Send Email Verification code response: ${response.statusCode}");
      // Get.snackbar("Message", "${response.body['message']}");

      if (response.isOk && response.body != null) {
        final rawBody = response.bodyString!;

        final decodedJson = utf8.decode(base64Decode(rawBody));

        final Map<String, dynamic> encryptedMap = jsonDecode(decodedJson);

        final cipherText = base64Decode(encryptedMap["value"]);
        final tag = base64Decode(encryptedMap["tag"]);
        final combined = Uint8List.fromList([...cipherText, ...tag]);

        final iv = IV.fromBase64(encryptedMap["iv"]);
        final encrypted = Encrypted(combined);

        final decryptedString = aesHelper.decryptText(encrypted, iv);

        final cleanJson = _stripPhpSerialized(decryptedString);
        dev.log("Clean JSON: $cleanJson");

        final Map<String, dynamic> data = jsonDecode(cleanJson);
        return Right(data);
      } else {
        return Left(ServerFailure("Send email verify code failed: ${response.statusText}"));
      }
    } catch (e) {
      dev.log("Send email verify code error: $e");
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> emailVerifyConfirm(String email, String code) async {
    try {
      final jsonBody = jsonEncode({"email": email, "code": code});
      final length = jsonBody.length;
      final phpSerialized = 's:$length:"$jsonBody";';

      final iv = IV.fromSecureRandom(12);
      final encrypted = aesHelper.encryptText(phpSerialized, iv);

      final decrypted = aesHelper.decryptText(encrypted, iv);
      dev.log("[DEBUG] Decrypted email verify confirm payload: $decrypted");

      final encryptedBytes = encrypted.bytes;
      final cipherText = encryptedBytes.sublist(0, encryptedBytes.length - 16);
      final tag = encryptedBytes.sublist(encryptedBytes.length - 16);

      final body = {
        "iv": base64Encode(iv.bytes),
        "value": base64Encode(cipherText),
        "mac": "",
        "tag": base64Encode(tag),
      };

      final bodyBase64 = base64Encode(utf8.encode(jsonEncode(body)));
      final response = await apiProvider.emailVerifyConfirm(bodyBase64);

      dev.log("email verify confirm response: ${response.statusCode}");

      if (response.isOk && response.body != null) {
        final rawBody = response.bodyString!;

        final decodedJson = utf8.decode(base64Decode(rawBody));

        final Map<String, dynamic> encryptedMap = jsonDecode(decodedJson);

        final cipherText = base64Decode(encryptedMap["value"]);
        final tag = base64Decode(encryptedMap["tag"]);
        final combined = Uint8List.fromList([...cipherText, ...tag]);

        final iv = IV.fromBase64(encryptedMap["iv"]);
        final encrypted = Encrypted(combined);

        final decryptedString = aesHelper.decryptText(encrypted, iv);

        final cleanJson = _stripPhpSerialized(decryptedString);
        dev.log("Clean JSON: $cleanJson");

        final Map<String, dynamic> data = jsonDecode(cleanJson);
        return Right(data);
      } else {
        return Left(ServerFailure("email verify confirm failed: ${response.statusText}"));
      }
    } catch (e) {
      dev.log("email verify confirm: $e");
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> kycUpdate(String bvn, String image) async {
    try {
      final jsonBody = jsonEncode({"bvn": bvn, "image": image});
      final length = jsonBody.length;
      final phpSerialized = 's:$length:"$jsonBody";';

      final iv = IV.fromSecureRandom(12);
      final encrypted = aesHelper.encryptText(phpSerialized, iv);

      final decrypted = aesHelper.decryptText(encrypted, iv);
      dev.log("[DEBUG] Decrypted Kyc Update payload: $decrypted");

      final encryptedBytes = encrypted.bytes;
      final cipherText = encryptedBytes.sublist(0, encryptedBytes.length - 16);
      final tag = encryptedBytes.sublist(encryptedBytes.length - 16);

      final body = {
        "iv": base64Encode(iv.bytes),
        "value": base64Encode(cipherText),
        "mac": "",
        "tag": base64Encode(tag),
      };

      final bodyBase64 = base64Encode(utf8.encode(jsonEncode(body)));
      final response = await apiProvider.kycUpdate(bodyBase64);

      dev.log("Kyc Update response: ${response.statusCode}");

      if (response.isOk && response.body != null) {
        final rawBody = response.bodyString!;

        final decodedJson = utf8.decode(base64Decode(rawBody));

        final Map<String, dynamic> encryptedMap = jsonDecode(decodedJson);

        final cipherText = base64Decode(encryptedMap["value"]);
        final tag = base64Decode(encryptedMap["tag"]);
        final combined = Uint8List.fromList([...cipherText, ...tag]);

        final iv = IV.fromBase64(encryptedMap["iv"]);
        final encrypted = Encrypted(combined);

        final decryptedString = aesHelper.decryptText(encrypted, iv);

        final cleanJson = _stripPhpSerialized(decryptedString);
        dev.log("Clean JSON: $cleanJson");

        final Map<String, dynamic> data = jsonDecode(cleanJson);
        return Right(data);
      } else {
        return Left(ServerFailure("Kyc Update failed: ${response.statusText}"));
      }
    } catch (e) {
      dev.log("Kyc Update: $e");
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> kycCheck(String bvn) async {
    try {
      final jsonBody = jsonEncode({"bvn": bvn});
      final length = jsonBody.length;
      final phpSerialized = 's:$length:"$jsonBody";';

      final iv = IV.fromSecureRandom(12);
      final encrypted = aesHelper.encryptText(phpSerialized, iv);

      final decrypted = aesHelper.decryptText(encrypted, iv);
      dev.log("[DEBUG] Decrypted Kyc Check payload: $decrypted");

      final encryptedBytes = encrypted.bytes;
      final cipherText = encryptedBytes.sublist(0, encryptedBytes.length - 16);
      final tag = encryptedBytes.sublist(encryptedBytes.length - 16);

      final body = {
        "iv": base64Encode(iv.bytes),
        "value": base64Encode(cipherText),
        "mac": "",
        "tag": base64Encode(tag),
      };

      final bodyBase64 = base64Encode(utf8.encode(jsonEncode(body)));
      final response = await apiProvider.kycCheck(bodyBase64);

      dev.log("Kyc Check response: ${response.statusCode}");

      if (response.isOk && response.body != null) {
        final rawBody = response.bodyString!;

        final decodedJson = utf8.decode(base64Decode(rawBody));

        final Map<String, dynamic> encryptedMap = jsonDecode(decodedJson);

        final cipherText = base64Decode(encryptedMap["value"]);
        final tag = base64Decode(encryptedMap["tag"]);
        final combined = Uint8List.fromList([...cipherText, ...tag]);

        final iv = IV.fromBase64(encryptedMap["iv"]);
        final encrypted = Encrypted(combined);

        final decryptedString = aesHelper.decryptText(encrypted, iv);

        final cleanJson = _stripPhpSerialized(decryptedString);
        dev.log("Clean JSON: $cleanJson");

        final Map<String, dynamic> data = jsonDecode(cleanJson);
        return Right(data);
      } else {
        return Left(ServerFailure("Kyc Check failed: ${response.statusText}"));
      }
    } catch (e) {
      dev.log("Kyc Check: $e");
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> kycValidate(String bvn, String reference, String imageUrl) async {
    try {
      final jsonBody = jsonEncode({"bvn": bvn, "reference": reference, "image_url": imageUrl});
      final length = jsonBody.length;
      final phpSerialized = 's:$length:"$jsonBody";';

      final iv = IV.fromSecureRandom(12);
      final encrypted = aesHelper.encryptText(phpSerialized, iv);

      final decrypted = aesHelper.decryptText(encrypted, iv);
      dev.log("[DEBUG] Decrypted Kyc Validate payload: $decrypted");

      final encryptedBytes = encrypted.bytes;
      final cipherText = encryptedBytes.sublist(0, encryptedBytes.length - 16);
      final tag = encryptedBytes.sublist(encryptedBytes.length - 16);

      final body = {
        "iv": base64Encode(iv.bytes),
        "value": base64Encode(cipherText),
        "mac": "",
        "tag": base64Encode(tag),
      };

      final bodyBase64 = base64Encode(utf8.encode(jsonEncode(body)));
      final response = await apiProvider.kycValidate(bodyBase64);

      dev.log("Kyc Validate response: ${response.statusCode}");

      if (response.isOk && response.body != null) {
        final rawBody = response.bodyString!;

        final decodedJson = utf8.decode(base64Decode(rawBody));

        final Map<String, dynamic> encryptedMap = jsonDecode(decodedJson);

        final cipherText = base64Decode(encryptedMap["value"]);
        final tag = base64Decode(encryptedMap["tag"]);
        final combined = Uint8List.fromList([...cipherText, ...tag]);

        final iv = IV.fromBase64(encryptedMap["iv"]);
        final encrypted = Encrypted(combined);

        final decryptedString = aesHelper.decryptText(encrypted, iv);

        final cleanJson = _stripPhpSerialized(decryptedString);
        dev.log("Clean JSON: $cleanJson");

        final Map<String, dynamic> data = jsonDecode(cleanJson);
        return Right(data);
      } else {
        return Left(ServerFailure("Kyc Validate failed: ${response.statusText}"));
      }
    } catch (e) {
      dev.log("Kyc Validate: $e");
      return Left(ServerFailure("Unexpected error: $e"));
    }
  }



}