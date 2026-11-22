import 'package:equatable/equatable.dart';

/// Abstract base class for domain failures in Clean Architecture.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Returned when a server error (e.g. 500) or HTTP error occurs.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred.']);
}

/// Returned when network connection issues occur.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error. Please check your connection.']);
}

/// Returned when the requested entity is not found (e.g. 404).
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'The requested user was not found.']);
}
