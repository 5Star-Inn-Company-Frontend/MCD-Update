import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

class AESHelper {
  final String _keyString;
  late final Key _key;

  AESHelper(this._keyString) {
    final keyBytes = utf8.encode(_keyString);
    if (keyBytes.length != 32) {
      throw ArgumentError(
          'AES-256 key must be exactly 32 bytes. Got ${keyBytes.length}.');
    }
    _key = Key(keyBytes);
  }

  Encrypted encryptText(String plainText, IV iv) {
    final encrypter = Encrypter(AES(_key, mode: AESMode.gcm));
    return encrypter.encrypt(plainText, iv: iv);
  }

  String decryptText(Encrypted encrypted, IV iv) {
    final encrypter = Encrypter(AES(_key, mode: AESMode.gcm));
    return encrypter.decrypt(encrypted, iv: iv);
  }
}

void main() async {
  // 🔑 Replace with your actual 32-char AES key
  const keyString = 'BaVkxaDFoNzI2U0FHa2o1OTJ2aytEeVY';
  final aesHelper = AESHelper(keyString);

  stdout.write("Enter mode (1 = Encrypt new text, 2 = Decrypt final base64 payload): ");
  final mode = stdin.readLineSync();

  if (mode == '1') {
    // === ENCRYPT FLOW ===
    stdout.write("Enter plain text: ");
    final input = stdin.readLineSync() ?? "";

    final iv = IV.fromSecureRandom(12);
    final encrypted = aesHelper.encryptText(input, iv);

    final cipherText = encrypted.bytes.sublist(0, encrypted.bytes.length - 16);
    final tag = encrypted.bytes.sublist(encrypted.bytes.length - 16);

    final body = {
      "iv": base64Encode(iv.bytes),
      "value": base64Encode(cipherText),
      "mac": "",
      "tag": base64Encode(tag),
    };

    final finalPayload = base64Encode(utf8.encode(jsonEncode(body)));

    print("\n=== Encrypted Result ===");
    print("IV: ${body["iv"]}");
    print("Value: ${body["value"]}");
    print("Tag: ${body["tag"]}");
    print("Final Payload (base64): $finalPayload");

    // Decrypt immediately for verification
    final decrypted = aesHelper.decryptText(encrypted, iv);
    print("\nDecrypted back: $decrypted");

  } else if (mode == '2') {
    // === DECRYPT FLOW ===
    stdout.write("Paste final base64 payload: ");
    final base64Input = stdin.readLineSync() ?? "";

    try {
      final decodedJson = jsonDecode(utf8.decode(base64Decode(base64Input)));
      final iv = IV(base64Decode(decodedJson["iv"]));
      final value = base64Decode(decodedJson["value"]);
      final tag = base64Decode(decodedJson["tag"]);

      // join cipher + tag back
      final encryptedBytes = [...value, ...tag];
      final encrypted = Encrypted(Uint8List.fromList(encryptedBytes));

      final decrypted = aesHelper.decryptText(encrypted, iv);

      print("\n=== Decrypted Result ===");
      print("Original text: $decrypted");

    } catch (e) {
      print("Failed to decrypt: $e");
    }
  } else {
    print("Invalid mode.");
  }
}


// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:encrypt/encrypt.dart';
// import 'package:http/http.dart' as http;

// class AESHelper {
//   final String _keyString;
//   late final Key _key;

//   AESHelper(this._keyString) {
//     final keyBytes = utf8.encode(_keyString);
//     if (keyBytes.length < 12) {
//       throw ArgumentError(
//           'AES-256 key must be exactly 32 bytes. Got ${keyBytes.length}.');
//     }
//     _key = Key(keyBytes);
//   }

//   String decryptGCM(String base64Payload) {
//     final decodedJson = jsonDecode(utf8.decode(base64Decode(base64Payload)));
//     final iv = IV(base64Decode(decodedJson["iv"]));
//     final value = base64Decode(decodedJson["value"]);
//     final tag = base64Decode(decodedJson["tag"]);

//     final encryptedBytes = [...value, ...tag];
//     final encrypted = Encrypted(Uint8List.fromList(encryptedBytes));

//     final encrypter = Encrypter(AES(_key, mode: AESMode.gcm));
//     return encrypter.decrypt(encrypted, iv: iv);
//   }

//   String decryptCBC(String base64Payload) {
//     final decodedJson = jsonDecode(utf8.decode(base64Decode(base64Payload)));
//     final iv = IV(base64Decode(decodedJson["iv"]));
//     final value = base64Decode(decodedJson["value"]);

//     final encrypted = Encrypted(value);
//     final encrypter = Encrypter(AES(_key, mode: AESMode.cbc, padding: "PKCS7"));
//     return encrypter.decrypt(encrypted, iv: iv);
//   }
// }

// Future<void> main() async {
//   // stdout.write("Enter AES key (32 chars): ");
//   final key = "BaVkxaDFoNzI2U0FHa2o1OTJ2aytEeVY";
//   final aesHelper = AESHelper(key);

//   while (true) {
//     stdout.write("\nEnter request type (get/post/exit): ");
//     final method = stdin.readLineSync()?.trim().toLowerCase();

//     if (method == 'exit') break;

//     stdout.write("Enter full endpoint URL: ");
//     final url = stdin.readLineSync()?.trim() ?? "";

//     Map<String, String> headers = {
//       // "Content-Type": "application/json",
//       // "Accept": "application/json",
//       "Content-Type": "application/json",
//       "device": "SKQ1.210908.001 | ... | Xiaomi | qcom | true",
//       // "Authorization": "Bearer ${GetStorage().read("token")}",
//     };

//     http.Response response;

//     if (method == 'post') {
//       stdout.write("Enter JSON body (or leave empty): ");
//       final bodyInput = stdin.readLineSync();
//       String? payload;

//       if (bodyInput != null && bodyInput.trim().isNotEmpty) {
//         payload = bodyInput;
//       }

//       response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: payload,
//       );
//     } else if (method == 'get') {
//       response = await http.get(Uri.parse(url), headers: headers);
//     } else {
//       print("Invalid request type.");
//       continue;
//     }

//     print("\n🔒 Encrypted Response (${response.statusCode}):\n${response.body}\n");

//     // Extract the base64 payload
//     try {
//       String base64Payload = response.body;
//       if (base64Payload.trim().startsWith('{')) {
//         final parsed = jsonDecode(response.body);
//         base64Payload = parsed["data"] ?? response.body;
//       }

//       try {
//         final decrypted = aesHelper.decryptGCM(base64Payload);
//         print("\nGCM Decrypted JSON:\n${_prettyPrint(decrypted)}");
//       } catch (_) {
//         final decrypted = aesHelper.decryptCBC(base64Payload);
//         print("\nCBC Decrypted JSON:\n${_prettyPrint(decrypted)}");
//       }
//     } catch (e) {
//       print("Failed to decrypt response: $e");
//     }
//   }
// }

// String _prettyPrint(String text) {
//   try {
//     final jsonObj = jsonDecode(text);
//     return const JsonEncoder.withIndent('  ').convert(jsonObj);
//   } catch (_) {
//     return text;
//   }
// }
