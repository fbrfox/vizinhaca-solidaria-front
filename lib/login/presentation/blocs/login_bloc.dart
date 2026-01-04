// Estados

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vizinhanca_solidaria/login/domain/entities/login_dto.dart';
import 'package:vizinhanca_solidaria/login/domain/entities/user.dart';
import 'package:vizinhanca_solidaria/login/domain/usecases/login_usecase.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;
  LoginSuccess(this.user);
}

class LoginSuccessToAddress extends LoginState {
  final User user;
  LoginSuccessToAddress(this.user);
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

class UnauthorizerFailure extends LoginState {
  final String message;
  UnauthorizerFailure(this.message);
}

// Eventos
abstract class LoginEvent {}

class LoginWithEmailAndPassword extends LoginEvent {
  final String username;
  final String password;
  final bool remember;
  LoginWithEmailAndPassword(this.username, this.password, this.remember);
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(LoginInitial()) {
    on<LoginWithEmailAndPassword>((event, emit) async {
      emit(LoginLoading());
      final result = await loginUseCase(
        LoginDto(
            username: event.username,
            password: event.password,
            remember: event.remember),
      );

      result.fold((failure) {
        emit(LoginFailure(failure.message));
      }, (user) {
        if (user.address.isEmpty) {
          emit(LoginSuccessToAddress(user));
        } else {
          emit(LoginSuccess(user));
        }
      });
    });
  }
}
