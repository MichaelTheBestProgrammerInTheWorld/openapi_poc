import 'package:equatable/equatable.dart';

/// Domain Entity representing a User in Clean Architecture.
class UserEntity extends Equatable {
  final int id;
  final String name;

  const UserEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
