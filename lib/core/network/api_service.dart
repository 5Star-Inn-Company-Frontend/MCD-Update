import 'dart:developer' as dev;
import 'package:get/get.dart';
import 'package:mcd/core/network/api_constants.dart';
import 'package:mcd/core/utils/aes_helper.dart';

class ApiService extends GetConnect {
  final aes = AESHelper(ApiConstants.encryptionKey);

  @override
  void onInit() {
    dev.log('[ApiService] Initializing API service');
    httpClient.baseUrl = ApiConstants.authUrlV2;
    httpClient.timeout = ApiConstants.apiTimeout;
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
      );
      dev.log('[ApiService] GET response status: ${response.statusCode}');
      return response;
    } catch (e) {
      dev.log('[ApiService] GET request failed', error: e);
      rethrow;
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
      );
      dev.log('[ApiService] POST response status: ${response.statusCode}');
      return response;
    } catch (e) {
      dev.log('[ApiService] POST request failed', error: e);
      rethrow;
    }
  }
}
