import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class AESHelper {
  final String _keyString;
  late final Key _key;

  AESHelper(this._keyString) {
    
    final keyBytes = utf8.encode(_keyString);
    if (keyBytes.length != 32) {
      throw ArgumentError('AES-256 key must be exactly 32 bytes. Got ${keyBytes.length}.');
    }
    _key = Key(keyBytes);
  }

  /// encrypting text with AES-256-GCM
  Encrypted encryptText(String plainText, IV iv) {
    final encrypter = Encrypter(AES(_key, mode: AESMode.gcm));

    return encrypter.encrypt(plainText, iv: iv);
  }

   String decryptText(Encrypted encrypted, IV ivB) {
    final encrypter = Encrypter(AES(_key, mode: AESMode.gcm));
    final decrypted = encrypter.decrypt(encrypted, iv: ivB);

    return decrypted;
  }
}
