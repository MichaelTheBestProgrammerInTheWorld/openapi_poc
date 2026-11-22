import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

/// Presentation layer BLoC managing User state.
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserUseCase getUserUseCase;

  UserBloc({required this.getUserUseCase}) : super(const UserInitialState()) {
    on<FetchUserEvent>(_onFetchUser);
    on<ResetUserEvent>(_onResetUser);
  }

  Future<void> _onFetchUser(
    FetchUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoadingState());

    final result = await getUserUseCase(event.userId);

    if (result.isSuccess && result.user != null) {
      emit(UserLoadedState(result.user!));
    } else if (result.isFailure && result.failure != null) {
      emit(UserErrorState(result.failure!.message));
    } else {
      emit(const UserErrorState('Unexpected error occurred.'));
    }
  }

  void _onResetUser(
    ResetUserEvent event,
    Emitter<UserState> emit,
  ) {
    emit(const UserInitialState());
  }
}
