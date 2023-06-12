import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:final_app_folder/bootstrap.dart';
import 'package:final_app_folder/core/extension/dio_extension.dart';


class HandleNetworkCall {
  HandleNetworkCall();

  final _dioClient = getIt<Dio>();

  Future<Either<String, Map<String, dynamic>>> getData(String url) async {
    try {
      final Response<Map<String, dynamic>> response = await _dioClient.get(url);
      if (response.statusCode == 200) {
        return right(response.data!);
      } else {
        return left('Something went wrong. Please try again');
      }
    } on DioError catch (error) {
      if (error.isUnauthorizedAccess) {
        return left(error.unAuthorizedMessage);
      } else if (error.noConnectionError) {
        return left('No connection');
      } else if ((error).type == DioErrorType.badResponse &&
          (error).response?.statusCode == 404) {
        return left('404 Not Url Found');
      }
      return left(error.serverErrorMessage);
    }
  }
}
