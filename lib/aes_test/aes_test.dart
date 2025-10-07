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
      print("❌ Failed to decrypt: $e");
    }
  } else {
    print("Invalid mode.");
  }
}
