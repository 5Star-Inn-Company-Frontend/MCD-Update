import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/core/network/api_constants.dart';
import 'package:mcd/core/network/errors.dart';
import 'package:mcd/core/utils/aes_helper.dart';

class ApiService extends GetConnect {
  final aes = AESHelper(ApiConstants.encryptionKey);
  final GetStorage _storage = GetStorage();

  // Default timeout duration (30 seconds)
  static const Duration defaultTimeout = Duration(seconds: 30);

  @override
  void onInit() {
    dev.log('[ApiService] Initializing API service');
    httpClient.baseUrl = ApiConstants.authUrlV2;
    // httpClient.timeout = ApiConstants.apiTimeout;
    // httpClient.timeout = const Duration(seconds: 120);
    // dev.log('[ApiService] ONINIT CALLED! Setting timeout to ${httpClient.timeout} seconds.');
    super.onInit();
  }

  @override
  Future<Response<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    T Function(dynamic)? decoder,
    Map<String, dynamic>? query,
  }) async {
    dev.log('[ApiService] GET request to: $url');
    try {
      final response = await super.get<T>(
        url,
        headers: headers,
        contentType: contentType,
        decoder: decoder,
        query: query,
      ).timeout(defaultTimeout);
      dev.log('[ApiService] GET response status: ${response.statusCode}');
      return response;
    } catch (e) {
      dev.log('[ApiService] GET request failed', error: e);
      rethrow;
    }
  }

  Future<dynamic> getrequest(
    String url, {
    String? contentType,
    Function(dynamic)? decoder,
    Map<String, dynamic>? query,
  }) async {
    var headers = {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
      "Authorization": "Bearer ${GetStorage().read("token")}",
    };
    var response = await get(url,
        contentType: contentType,
        decoder: decoder,
        query: query,
        headers: headers);
    if (response.isOk && response.body != null) {
      final rawBody = response.bodyString!;
      return decryptjson(rawBody);
    }else if (response.statusCode == 401){
      GetStorage().remove("token");
      Get.offAllNamed(Routes.LOGIN_SCREEN);
    }else{
      dev.log('Request failed: ${response.statusText}');
      return Left(ServerFailure("Request failed: ${response.statusText}"));
    }
  }

  // using this new method for unencrypted GET requests like /airtime
  Future<Either<Failure, Map<String, dynamic>>> getJsonRequest(
    String url, {
    Map<String, dynamic>? query,
  }) async {
    var headers = {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
      "Authorization": "Bearer ${GetStorage().read("token")}",
    };

    try {
      var response = await get(url, query: query, headers: headers);

      if (response.isOk && response.body != null) {
        final Map<String, dynamic> data = jsonDecode(response.bodyString!);
        return Right(data);
      } else if (response.statusCode == 401) {
        GetStorage().remove("token");
        Get.offAllNamed(Routes.LOGIN_SCREEN);
        return Left(ServerFailure("Unauthorized. Please log in again."));
      } else {
        return Left(ServerFailure("Request failed: ${response.statusText}"));
      }
    } catch (e) {
      dev.log("getJsonRequest failed", error: e);
      return Left(ServerFailure("An unexpected error occurred: $e"));
    }
  }

  @override
  Future<Response<T>> post<T>(
    String? url,
    dynamic body, {
    Map<String, String>? headers,
    String? contentType,
    T Function(dynamic)? decoder,
    Map<String, dynamic>? query,
    Function(double)? uploadProgress,
  }) async {
    dev.log('[ApiService] POST request to: $url');
    try {
      final response = await super.post<T>(
        url,
        body,
        headers: headers,
        contentType: contentType,
        decoder: decoder,
        query: query,
        uploadProgress: uploadProgress,
      ).timeout(defaultTimeout);
      dev.log('[ApiService] POST response status: ${response.statusCode}');
      return response;
    } catch (e, stackTrace) {
      dev.log('[ApiService] POST request failed', error: e, stackTrace: stackTrace);
      return Response<T>(statusCode: null, statusText: e.toString());
    }
  }

  Future<dynamic> postrequest(
    String? url,
    dynamic body, {
    Map<String, String>? headers,
    String? contentType,
    Function(dynamic)? decoder,
    Map<String, dynamic>? query,
    Function(double)? uploadProgress,
  }) async {
    var headers = {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
      "Authorization": "Bearer ${GetStorage().read("token")}",
    };
    var response = await post(url, encryptjson(body),
        contentType: contentType,
        decoder: decoder,
        query: query,
        headers: headers);
    if (response.isOk && response.body != null) {
      final rawBody = response.bodyString!;
      return decryptjson(rawBody);
    }else if (response.statusCode == 401){
      GetStorage().remove("token");
      Get.offAllNamed("/login");
    }else{
      dev.log("Request failed: ${response.statusText}");
      return Left(ServerFailure("Request failed: ${response.statusText}"));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> postJsonRequest(
    String url,
    Map<String, dynamic> body,
  ) async {
    dev.log('[ApiService] POST request to: $url');
    var headers = {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
      "Authorization": "Bearer ${GetStorage().read("token")}",
    };

    try {
      var response = await super.post(url, jsonEncode(body), headers: headers);
      dev.log('[ApiService] POST response status: ${response.statusCode}');

      if (response.isOk && response.body != null) {
        final Map<String, dynamic> data = jsonDecode(response.bodyString!);
        return Right(data);
      } else if (response.statusCode == 401) {
        GetStorage().remove("token");
        Get.offAllNamed(Routes.LOGIN_SCREEN);
        return Left(ServerFailure("Unauthorized. Please log in again."));
      } else {
        dev.log('[ApiService] POST response status: ${response.statusText}');
        return Left(ServerFailure("Request failed: ${response.statusText}"));
      }
    } catch (e) {
      dev.log("postJsonRequest failed", error: e);
      return Left(ServerFailure("An unexpected error occurred: $e"));
    }
  }

  @override
  Future<Response<T>> put<T>(String url, body, {String? contentType, Map<String, String>? headers, Map<String, dynamic>? query, Decoder<T>? decoder, Progress? uploadProgress}) async {
    dev.log('[ApiService] PUT request to: $url');
    try {
      final response = await super.put(url, body, contentType: contentType,
          headers: headers,
          query: query,
          decoder: decoder,
          uploadProgress: uploadProgress).timeout(defaultTimeout);
      dev.log('[ApiService] POST response status: ${response.statusCode}');
      return response;
    } catch (e, stackTrace) {
      dev.log('[ApiService] POST request failed', error: e, stackTrace: stackTrace);
      return Response<T>(statusCode: null, statusText: e.toString());
    }
  }

  Future<dynamic> putrequest(
      String? url,
      dynamic body, {
        Map<String, String>? headers,
        String? contentType,
        Function(dynamic)? decoder,
        Map<String, dynamic>? query,
        Function(double)? uploadProgress,
      }) async {
    var headers = {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
      "Authorization": "Bearer ${GetStorage().read("token")}",
    };
    var response = await put(url!, encryptjson(body),
        contentType: contentType,
        decoder: decoder,
        query: query,
        headers: headers);
    if (response.isOk && response.body != null) {
      final rawBody = response.bodyString!;
      return decryptjson(rawBody);
    }else if (response.statusCode == 401){
      GetStorage().remove("token");
      Get.offAllNamed("/login");
    }else{
      dev.log("Request failed: ${response.statusText}");
      return Left(ServerFailure("Request failed: ${response.statusText}"));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> putJsonRequest(
      String? url,
      dynamic body, {
        Map<String, String>? headers,
        String? contentType,
        Function(dynamic)? decoder,
        Map<String, dynamic>? query,
        Function(double)? uploadProgress,
      }) async {
    var headers = {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
      "Authorization": "Bearer ${GetStorage().read("token")}",
    };
    var response = await put(url!, jsonEncode(body),
        contentType: contentType,
        decoder: decoder,
        query: query,
        headers: headers);
    if (response.isOk && response.body != null) {
      final Map<String, dynamic> data = jsonDecode(response.bodyString!);
      return Right(data);
    } else if (response.statusCode == 401) {
      GetStorage().remove("token");
      Get.offAllNamed(Routes.LOGIN_SCREEN);
      return Left(ServerFailure("Unauthorized. Please log in again."));
    } else {
      dev.log('[ApiService] POST response status: ${response.statusText}');
      return Left(ServerFailure("Request failed: ${response.statusText}"));
    }
  }

  String encryptjson(toencrypt) {
    final payload = jsonEncode(toencrypt);
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
    return bodyBase64;
  }

  Right<dynamic, Map<String, dynamic>> decryptjson(String rawBody) {
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
  }

  String _stripPhpSerialized(String decrypted) {
    final regex = RegExp(r's:\d+:"(.*)";$', dotAll: true);
    final match = regex.firstMatch(decrypted);
    if (match != null) {
      return match.group(1)!; // inner JSON string
    }
    throw FormatException("Invalid serialized format");
  }

  final aesHelper = AESHelper(ApiConstants.encryptionKey);
}
