import '../repositories/user_repository.dart';

/// Clean Architecture Use Case for fetching a User by ID.
class GetUserUseCase {
  final UserRepository repository;

  const GetUserUseCase(this.repository);

  /// Executes the use case for the given [id].
  Future<UserResult> call(int id) async {
    return await repository.getUser(id);
  }
}
