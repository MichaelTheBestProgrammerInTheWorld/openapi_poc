import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered to fetch user details by ID via OpenAPI endpoint.
class FetchUserEvent extends UserEvent {
  final int userId;

  const FetchUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Event to reset state to initial.
class ResetUserEvent extends UserEvent {
  const ResetUserEvent();
}
