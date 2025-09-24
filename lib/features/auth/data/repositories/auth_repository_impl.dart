import 'dart:convert';
import 'dart:developer' as dev;
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

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiProvider apiProvider;
  final AESHelper aesHelper;
  final box = GetStorage();

  AuthRepositoryImpl(this.apiProvider, this.aesHelper);

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

  
}