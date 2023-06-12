import 'dart:async';

import 'package:dio/dio.dart';
import 'package:final_app_folder/bootstrap.dart';
import 'package:final_app_folder/core/extension/dio_extension.dart';


/// [BaseSource] for handling network requests for dio client
class BaseSource {
  BaseSource();

  final dioClient = getIt<Dio>();

  /// [T] is return type from network request
  ///
  /// [request] callback returns [Response] and accepts [Dio] instance
  ///
  /// [onResponse] callback returns [T] and accepts [dynamic] data from [Response]
  ///
  /// throws [ApiException]

  Future<T> networkHandler<T>({
    required Future<Response<Map<String, dynamic>>> Function(Dio dio) request,
    required FutureOr<T> Function(Map<String, dynamic> data) onResponse,
  }) async {
    try {
      final Response<Map<String, dynamic>> response = await request(dioClient);
      if (response.statusCode == 200) {
        return await onResponse(response.data!);
      } else {
        throw 'UnExpected Error Occurred!!!';
      }
    } on DioError catch (e) {
      throw e.toApiException;
    } catch (e) {
      throw e.toString();
    }
  }
}


