import '../../../../api/generated/api/user_api.dart';
import '../../../../api/generated/model/user_dto.dart';

/// Abstract Data Source interface for User remote operations.
abstract class UserRemoteDataSource {
  Future<UserDto> getUser(int id);
}

/// Implementation of [UserRemoteDataSource] using OpenAPI generated [UserApi].
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final UserApi userApi;

  UserRemoteDataSourceImpl(this.userApi);

  @override
  Future<UserDto> getUser(int id) async {
    final response = await userApi.getUser(id: id);
    if (response.data != null) {
      return response.data!;
    } else {
      throw Exception('Empty user data received from API');
    }
  }
}
