import 'package:dio/dio.dart';
import 'api/user_api.dart';

/// Generated OpenAPI Client container using Dio.
class ApiClient {
  final Dio dio;
  final String basePath;

  late final UserApi userApi;

  ApiClient({
    Dio? dio,
    String? basePath,
  })  : dio = dio ?? Dio(),
        basePath = basePath ?? 'https://api.mycompany.com' {
    userApi = UserApi(this.dio, basePath: this.basePath);
  }
}
