import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

/// User Repository interface in the Domain layer.
abstract class UserRepository {
  /// Fetches a [UserEntity] by its [id].
  /// Returns a tuple-like result or throws a [Failure].
  Future<UserResult> getUser(int id);
}

/// Simple result wrapper encapsulating either a [UserEntity] or a [Failure].
class UserResult extends Equatable {
  final UserEntity? user;
  final Failure? failure;

  const UserResult._({this.user, this.failure});

  factory UserResult.success(UserEntity user) => UserResult._(user: user);
  factory UserResult.failure(Failure failure) => UserResult._(failure: failure);

  bool get isSuccess => user != null;
  bool get isFailure => failure != null;

  @override
  List<Object?> get props => [user, failure];
}
