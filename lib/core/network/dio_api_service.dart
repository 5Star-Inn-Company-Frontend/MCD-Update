import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/core/network/api_constants.dart';
import 'package:mcd/core/network/errors.dart';
import 'package:mcd/core/utils/aes_helper.dart';

class DioApiService {
  final Dio _dio;
  final AESHelper _aes = AESHelper(ApiConstants.encryptionKey);
  final GetStorage _storage = GetStorage();

  // Default timeout duration (30 seconds)
  static const Duration defaultTimeout = Duration(seconds: 30);

  DioApiService() : _dio = Dio() {
    dev.log('[DioApiService] Initializing API service');
    _dio.options.baseUrl = ApiConstants.authUrlV2;
    _dio.options.connectTimeout = defaultTimeout;
    _dio.options.receiveTimeout = defaultTimeout;
    _dio.options.validateStatus = (status) {
      // Allow all status codes to be handled in the success block
      return status != null;
    };
    dev.log(
        '[DioApiService] ONINIT CALLED! Setting timeout to ${defaultTimeout.inSeconds} seconds.');
  }

  Future<Either<Failure, Map<String, dynamic>>> getrequest(
    String url, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: query,
        options: Options(headers: _getHeaders()),
      );
      if (response.statusCode == 200 && response.data != null) {
        final rawBody = response.data.toString();
        return decryptjson(rawBody);
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
        return Left(ServerFailure("Unauthorized"));
      } else {
        return Left(
            ServerFailure("Request failed: ${response.statusMessage}"));
      }
    } on DioError catch (e) {
      dev.log('[DioApiService] GET request failed', error: e);
      return Left(ServerFailure(_handleDioError(e)));
    } catch (e) {
      dev.log('[DioApiService] GET request failed', error: e);
      return Left(ServerFailure("An unexpected error occurred: $e"));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getJsonRequest(
    String url, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: query,
        options: Options(headers: _getHeaders()),
      );

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        return Right(data);
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
        return Left(ServerFailure("Unauthorized. Please log in again."));
      } else {
        return Left(
            ServerFailure("Request failed: ${response.statusMessage}"));
      }
    } on DioError catch (e) {
      dev.log("getJsonRequest failed", error: e);
      return Left(ServerFailure(_handleDioError(e)));
    } catch (e) {
      dev.log("getJsonRequest failed", error: e);
      return Left(ServerFailure("An unexpected error occurred: $e"));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> postrequest(
    String url,
    dynamic body,
  ) async {
    try {
      final response = await _dio.post(
        url,
        data: encryptjson(body),
        options: Options(headers: _getHeaders()),
      );
      if (response.statusCode == 200 && response.data != null) {
        final rawBody = response.data.toString();
        return decryptjson(rawBody);
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
        return Left(ServerFailure("Unauthorized"));
      } else {
        return Left(
            ServerFailure("Request failed: ${response.statusMessage}"));
      }
    } on DioError catch (e) {
      dev.log('[DioApiService] POST request failed', error: e);
      return Left(ServerFailure(_handleDioError(e)));
    } catch (e) {
      dev.log('[DioApiService] POST request failed', error: e);
      return Left(ServerFailure("An unexpected error occurred: $e"));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> postJsonRequest(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.post(
        url,
        data: jsonEncode(body),
        options: Options(headers: _getHeaders()),
      );

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        return Right(data);
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
        return Left(ServerFailure("Unauthorized. Please log in again."));
      } else {
        return Left(
            ServerFailure("Request failed: ${response.statusMessage}"));
      }
    } on DioError catch (e) {
      dev.log("postJsonRequest failed", error: e);
      return Left(ServerFailure(_handleDioError(e)));
    } catch (e) {
      dev.log("postJsonRequest failed", error: e);
      return Left(ServerFailure("An unexpected error occurred: $e"));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> putrequest(
    String url,
    dynamic body,
  ) async {
    try {
      final response = await _dio.put(
        url,
        data: encryptjson(body),
        options: Options(headers: _getHeaders()),
      );
      if (response.statusCode == 200 && response.data != null) {
        final rawBody = response.data.toString();
        return decryptjson(rawBody);
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
        return Left(ServerFailure("Unauthorized"));
      } else {
        return Left(
            ServerFailure("Request failed: ${response.statusMessage}"));
      }
    } on DioError catch (e) {
      dev.log('[DioApiService] PUT request failed', error: e);
      return Left(ServerFailure(_handleDioError(e)));
    } catch (e) {
      dev.log('[DioApiService] PUT request failed', error: e);
      return Left(ServerFailure("An unexpected error occurred: $e"));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> putJsonRequest(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.put(
        url,
        data: jsonEncode(body),
        options: Options(headers: _getHeaders()),
      );
      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        return Right(data);
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
        return Left(ServerFailure("Unauthorized. Please log in again."));
      } else {
        return Left(
            ServerFailure("Request failed: ${response.statusMessage}"));
      }
    } on DioError catch (e) {
      dev.log("putJsonRequest failed", error: e);
      return Left(ServerFailure(_handleDioError(e)));
    } catch (e) {
      dev.log("putJsonRequest failed", error: e);
      return Left(ServerFailure("An unexpected error occurred: $e"));
    }
  }

  Map<String, String> _getHeaders() {
    return {
      "Content-Type": "application/json",
      "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
      "Authorization": "Bearer ${_storage.read("token")}",
    };
  }

  void _handleUnauthorized() {
    _storage.remove("token");
    Get.offAllNamed(Routes.LOGIN_SCREEN);
  }

  String _handleDioError(DioError e) {
    if (e.type == DioErrorType.connectionTimeout ||
        e.type == DioErrorType.receiveTimeout) {
      return "Connection timed out";
    }
    if (e.response != null) {
      return "Request failed: ${e.response?.statusCode} ${e.response?.statusMessage}";
    }
    return "Request failed: ${e.message}";
  }

  String encryptjson(toencrypt) {
    final payload = jsonEncode(toencrypt);
    final length = payload.length;
    final phpSerialized = 's:$length:"$payload";';

    final iv = IV.fromSecureRandom(12);
    final encrypted = _aes.encryptText(phpSerialized, iv);

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

  Right<Failure, Map<String, dynamic>> decryptjson(String rawBody) {
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
    final decryptedString = _aes.decryptText(encrypted, iv);
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
}
