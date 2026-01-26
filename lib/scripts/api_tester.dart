import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';

/// A robust script to test API endpoints mimicking the app's encryption layer.
///
/// Usage:
/// dart run lib/scripts/api_tester.dart <METHOD> <URL> [BODY_JSON] [TOKEN]
///
/// Examples:
/// dart run lib/scripts/api_tester.dart GET https://auth.mcd.5starcompany.com.ng/api/v2/user/profile "" "eyJ..."
/// dart run lib/scripts/api_tester.dart POST https://auth.mcd.5starcompany.com.ng/api/v2/auth/login "{\"email\": \"...\", \"password\": \"...\"}"

// Constants copied from ApiConstants
const String encryptionKey = "BaVkxaDFoNzI2U0FHa2o1OTJ2aytEeVY";
const String appVersion = '1.0.0';
const String defaultDevice = 'CLI Script | Windows | Dart';

void main(List<String> args) async {
  if (args.length < 2) {
    print(
        'Usage: dart run lib/scripts/api_tester.dart <METHOD> <URL> [BODY_JSON] [TOKEN]');
    exit(1);
  }

  final method = args[0].toUpperCase();
  final url = args[1];
  final bodyString = args.length > 2 ? args[2] : null;
  final token = args.length > 3 ? args[3] : null;

  dynamic body;
  if (bodyString != null && bodyString.isNotEmpty) {
    try {
      body = jsonDecode(bodyString);
    } catch (e) {
      print('Warning: Body is not valid JSON, sending as string.');
      body = bodyString;
    }
  }

  print('\n=== API REQUEST ===');
  print('Method: $method');
  print('URL: $url');

  // Headers
  final headers = {
    "Content-Type": "application/json",
    "device": defaultDevice,
    "version": appVersion,
    "Authorization": "Bearer ${token ?? ''}",
  };

  final dio = Dio();
  dio.options.validateStatus = (_) => true;

  try {
    Response response;
    dynamic requestData;

    // Encrypt Body if POST/PUT/PATCH
    if (['POST', 'PUT', 'PATCH'].contains(method) && body != null) {
      print('Encrypting body...');
      final encryptedBody = encryptjson(body);
      requestData = encryptedBody; // Dio will jsonEncode this map
    } else {
      requestData = body;
    }

    final options = Options(
      method: method,
      headers: headers,
    );

    final stopwatch = Stopwatch()..start();
    response = await dio.request(
      url,
      data: requestData,
      options: options,
    );
    stopwatch.stop();

    print('\n=== API RESPONSE (${stopwatch.elapsedMilliseconds}ms) ===');
    print('Status: ${response.statusCode}');

    if (response.data != null) {
      // Decrypt logic
      if (response.data is String) {
        // Some errors return plain text
        print('Raw Response: ${response.data}');
        try {
          final decrypted = decryptjson(response.data);
          print('\n--- Decrypted JSON ---');
          printPretty(decrypted);
        } catch (e) {
          print('Could not decrypt response (might be plain text error): $e');
        }
      } else if (response.data is Map) {
        // Sometimes Dio parses JSON automatically.
        // If it's the encrypted format {iv, value, mac, tag}, we need to treat it as such.
        // But usually `decryptjson` expects the raw string representation for base64 decoding.
        // Let's re-encode to string if needed, or handle map directly.
        // The `DioApiService` logic takes `response.data.toString()`.

        final rawBody = jsonEncode(response.data);
        try {
          final decrypted = decryptjson(rawBody);
          print('\n--- Decrypted JSON ---');
          printPretty(decrypted);
        } catch (e) {
          print('Could not decrypt response: $e');
          printPretty(response.data);
        }
      } else {
        print('Response Data: ${response.data}');
      }
    }
  } catch (e) {
    print('Error: $e');
    if (e is DioException) {
      print('Dio Message: ${e.message}');
      if (e.response != null) {
        print('Server Response: ${e.response?.data}');
      }
    }
  }
}

void printPretty(dynamic json) {
  try {
    final encoder = JsonEncoder.withIndent('  ');
    print(encoder.convert(json));
  } catch (e) {
    print(json);
  }
}

// --- Encryption Logic Copied from DioApiService & AESHelper ---

final AESHelper _aes = AESHelper(encryptionKey);

String encryptjson(dynamic toencrypt) {
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

  // The API expects a Base64 string of the JSON object
  final bodyBase64 = base64Encode(utf8.encode(jsonEncode(body)));
  return bodyBase64; // Dio sends this as a string body?
  // Wait, DioApiService sends `data: encryptjson(body)`.
  // encryptjson returns a String.
  // So request body is "eyJ..." (quoted string).
  // Dio, with Content-Type: application/json, will default to sending it as is or json encoded?
  // If requestData is a String, Dio sends it as is.
  // The app sends `data: encryptjson(body)` where `encryptjson` returns a String.
}

dynamic decryptjson(String rawBody) {
  // Step 1: Decode from base64
  // The rawBody might be just the base64 string "eyJ..." or a JSON string "..."
  // If Dio returns it as a String, it might be the direct response body.

  // Try rigorous decode
  String decodedJson;
  try {
    // If rawBody is wrapped in quotes, unwrap or decode json?
    // Actually rawBody from response.data.toString() usually works.
    // But response.data might be a Map if Dio parsed it.
    // If response.data is String, it is likely the base64 blob.

    // Clean potential quotes
    if (rawBody.startsWith('"') && rawBody.endsWith('"')) {
      rawBody = jsonDecode(rawBody);
    }

    decodedJson = utf8.decode(base64Decode(rawBody));
  } catch (e) {
    // If failed, maybe it wasn't base64 encoded or double encoded
    throw FormatException("Failed to base64 decode body: $e");
  }

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

  // Step 5: Strip PHP serialization
  final cleanJson = _stripPhpSerialized(decryptedString);

  // Step 6: Parse actual API response
  return jsonDecode(cleanJson);
}

String _stripPhpSerialized(String decrypted) {
  final regex = RegExp(r's:\d+:"(.*)";$', dotAll: true);
  final match = regex.firstMatch(decrypted);
  if (match != null) {
    return match.group(1)!;
  }
  throw FormatException("Invalid serialized format: $decrypted");
}

class AESHelper {
  final String _keyString;
  late final Key _key;

  AESHelper(this._keyString) {
    final keyBytes = utf8.encode(_keyString);
    if (keyBytes.length != 32) {
      throw ArgumentError('AES-256 key must be exactly 32 bytes.');
    }
    _key = Key(keyBytes);
  }

  Encrypted encryptText(String plainText, IV iv) {
    final encrypter = Encrypter(AES(_key, mode: AESMode.gcm));
    return encrypter.encrypt(plainText, iv: iv);
  }

  String decryptText(Encrypted encrypted, IV ivB) {
    final encrypter = Encrypter(AES(_key, mode: AESMode.gcm));
    return encrypter.decrypt(encrypted, iv: ivB);
  }
}
