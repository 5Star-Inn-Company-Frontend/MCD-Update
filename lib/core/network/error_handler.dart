import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:logger/logger.dart';
import 'package:mcd/core/utils/logger.dart';

class ErrorHandler {

  /// Function to handle error messages from the server
  void handleError(dynamic e) {
    print(e);
    if (e is HandshakeException || e.toString().contains('HandshakeException')) {
      throw ("Error occurred, please try again");
    }
    else if(e is SocketException || e.toString().contains('SocketException')){
      throw ("No internet connection");
    }
    if(e is TimeoutException || e.toString().contains('TimeoutException')){
      throw ("Request timeout, try again");
    }
    if(e is FormatException || e.toString().contains('FormatException')){
      throw ("Error occurred, please try again");
    }
    if (e is DioException) {
      if (e.type == DioExceptionType.badResponse) {
        logger.e(e.response);
        throw (e.response?.data['message'] ?? e.message);
      }
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
        throw ("Error occurred, please try again");
      }
       throw (e.response?.data['message'] ?? e.response?.data['error'] ?? e.message);
    }
    if (e['success'] != null && e['success'] == false) {
       throw (e['message'] ?? e['error']);
    }
    throw('Error in requests, try again');

  }

}


class ApiException implements Exception {
  final int? statusCode;
  final String message;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException(status: $statusCode, message: $message)';
}

/// Helper to create readable error messages from GetConnect responses
String parseError(dynamic responseBody) {
  try {
    if (responseBody == null) return 'Empty response';
    if (responseBody is Map && responseBody['message'] != null) {
      return responseBody['message'].toString();
    }
    return responseBody.toString();
  } catch (_) {
    return 'Unknown error';
  }
}
