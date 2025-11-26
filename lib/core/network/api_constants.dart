// String baseurl = 'https://test.mcd.5starcompany.com.ng/api/v2';
// String liveurl = 'https://app.mcd.5starcompany.com.ng/api/v2';
// String authurl = 'https://auth.mcd.5starcompany.com.ng/api/v1';
// String encryptionkey = '';

class ApiConstants {
  static const String baseUrl = 'https://test.mcd.5starcompany.com.ng/api/v2';
  static const String authUrlV2 = 'https://auth.mcd.5starcompany.com.ng/api/v2';
  static const String temporaryTransUrl = 'https://transactiontest.mcd.5starcompany.com.ng';

  // AES key/iv placeholders.
  static const String encryptionKey = "BaVkxaDFoNzI2U0FHa2o1OTJ2aytEeVY";
  static const String encryptionIv  = '';

  // Sprint Check SDK keys
  static const String sprintCheckApiKey = "scb1edcd88-64f7485186d9781ca624a904";
  static const String sprintCheckEncryptionKey = "enc67fe4978b16fc1744718201";

  // Other app-wide constants
  static const Duration apiTimeout = Duration(seconds: 120);
}
