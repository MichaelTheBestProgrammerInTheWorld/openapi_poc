import 'package:dio/dio.dart';

/// Factory for creating and configuring [Dio] instances.
/// 
/// Includes a simulated network interceptor to allow the sample project
/// to be fully functional out-of-the-box without requiring a running live backend server.
class DioClientFactory {
  static Dio createDio({String? baseUrl, bool enableSimulatedBackend = true}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? 'https://api.mycompany.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (enableSimulatedBackend) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // Check if request matches GET /users/{id}
            final path = options.path;
            final userPathRegex = RegExp(r'/users/(\d+)');
            final match = userPathRegex.firstMatch(path);

            if (options.method == 'GET' && match != null) {
              final idStr = match.group(1);
              final userId = int.tryParse(idStr ?? '');

              // Simulate brief network delay
              await Future.delayed(const Duration(milliseconds: 600));

              if (userId == null || userId <= 0) {
                return handler.reject(
                  DioException(
                    requestOptions: options,
                    response: Response(
                      requestOptions: options,
                      statusCode: 400,
                      data: {'error': 'Invalid User ID'},
                    ),
                    type: DioExceptionType.badResponse,
                  ),
                );
              }

              if (userId == 404) {
                return handler.reject(
                  DioException(
                    requestOptions: options,
                    response: Response(
                      requestOptions: options,
                      statusCode: 404,
                      data: {'error': 'User not found'},
                    ),
                    type: DioExceptionType.badResponse,
                  ),
                );
              }

              // Mock names based on ID for demo
              final mockNames = {
                1: 'Alice Smith',
                2: 'Bob Jones',
                3: 'Charlie Brown',
                42: 'Douglas Adams',
                100: 'John Doe',
              };

              final userName = mockNames[userId] ?? 'User #$userId';

              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'id': userId,
                    'name': userName,
                  },
                ),
              );
            }

            return handler.next(options);
          },
        ),
      );
    }

    // Add LogInterceptor for debugging network requests in console
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        responseHeader: false,
        requestBody: true,
        responseBody: true,
      ),
    );

    return dio;
  }
}
