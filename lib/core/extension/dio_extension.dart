import 'dart:io';

import 'package:dio/dio.dart';
import 'package:final_app_folder/core/exception/api_exception.dart';

extension DioErrorX on DioError {
  ApiException get toApiException {
    switch (type) {
      case DioErrorType.badResponse:
        final statusCode = response?.statusCode;
        if (statusCode == 200) {
          final error = response?.data as Map<String, dynamic>;
          return ApiException.errorFromBacked(message: error.toString());
        }
        return ApiException.serverException(
            message:
                'we are unable to process your request. Please try again later.');

      case DioErrorType.connectionTimeout:
        // TODO: Handle this case.
        break;
      case DioErrorType.sendTimeout:
        // TODO: Handle this case.
        break;
      case DioErrorType.receiveTimeout:
        // TODO: Handle this case.
        break;
      case DioErrorType.badCertificate:
        // TODO: Handle this case.
        break;
      case DioErrorType.cancel:
        // TODO: Handle this case.
        break;
      case DioErrorType.connectionError:
        return ApiException.networkError();

      case DioErrorType.unknown:
        // TODO: Handle this case.
        break;
    }
    return ApiException.networkError();
  }

  bool get noConnectionError =>
      type == DioErrorType.connectionError && error is SocketException;

  bool get isUnauthorizedAccess =>
      type == DioErrorType.badResponse && response?.statusCode == 401;

  String get serverErrorMessage => 'Server Error';
  String get unAuthorizedMessage => 'Unauthorized Error';
}

extension StringX on String {
  int get parseToInt => int.parse(this);
}
