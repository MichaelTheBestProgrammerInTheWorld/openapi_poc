import 'package:dio/dio.dart';
import '../model/user_dto.dart';

/// Generated API Service for User operations from openapi.yaml
class UserApi {
  final Dio dio;
  final String basePath;

  UserApi(this.dio, {this.basePath = 'https://api.mycompany.com'});

  /// GET /users/{id}
  /// 
  /// Retrieves a user by their unique integer ID.
  Future<Response<UserDto>> getUser({
    required int id,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) async {
    final path = '/users/$id';
    final options = Options(
      method: 'GET',
      headers: headers,
    );

    final response = await dio.request<Map<String, dynamic>>(
      '$basePath$path',
      options: options,
      cancelToken: cancelToken,
    );

    if (response.data != null) {
      final userDto = UserDto.fromJson(response.data!);
      return Response<UserDto>(
        data: userDto,
        headers: response.headers,
        requestOptions: response.requestOptions,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
        isRedirect: response.isRedirect,
        redirects: response.redirects,
        extra: response.extra,
      );
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Received empty response body',
      );
    }
  }
}
