import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

/// Data layer implementation of [UserRepository].
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserResult> getUser(int id) async {
    try {
      final userDto = await remoteDataSource.getUser(id);

      // Map generated OpenAPI UserDto -> Domain UserEntity
      final userEntity = UserEntity(
        id: userDto.id ?? id,
        name: userDto.name ?? 'Unknown User',
      );

      return UserResult.success(userEntity);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return UserResult.failure(const NotFoundFailure());
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return UserResult.failure(const NetworkFailure());
      } else {
        final msg = e.response?.data?['error']?.toString() ?? e.message ?? 'An error occurred';
        return UserResult.failure(ServerFailure(msg));
      }
    } catch (e) {
      return UserResult.failure(ServerFailure(e.toString()));
    }
  }
}
