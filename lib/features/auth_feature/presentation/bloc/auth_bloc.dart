import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/core/params/auth_params.dart';
import 'package:nike/core/utils/exeption.dart';
import 'package:nike/features/auth_feature/data/repository/auth_repository.dart';
import 'package:nike/features/basket_feature/data/repository/basket_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  bool isLogedinMode;

  AuthBloc({
    required this.authRepository,
    this.isLogedinMode = true,
  }) : super(AuthInitState(isLogedinMode)) {
    on<AuthEvent>(
      (event, emit) async {
        try {
          if (event is AuthButtonPressed) {
            emit(AuthLoadingState(isLogedinMode));

            if (isLogedinMode) {
              await authRepository.logIn(AuthParams(
                username: event.email,
                password: event.password,
              ));

              await basketRepository.getCount();

              emit(AuthSuccessState(isLogedinMode));
            } else {
              await authRepository.singUp(AuthParams(
                username: event.email,
                password: event.password,
              ));
              emit(AuthSuccessState(isLogedinMode));
            }
          } else if (event is AuthModeChangePressed) {
            isLogedinMode = !isLogedinMode;
            emit(AuthInitState(isLogedinMode));
          }
        } catch (ex) {
          emit(
            AuthErrorState(isLogedinMode, AppExeption()),
          );
        }
      },
    );
  }
}
