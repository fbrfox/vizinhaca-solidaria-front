import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vizinhanca_solidaria/core/ui/file_extensions.dart';
import 'package:vizinhanca_solidaria/register/domain/entities/register_dto.dart';
import 'package:vizinhanca_solidaria/register/domain/usecases/register_usecase.dart';

abstract class RegisterEvent {}

class RegisterWithEmailAndPassword extends RegisterEvent {
  final String username;
  final String password;
  final String confirmPassword;
  final String email;
  final String name;
  final File? avatar;

  RegisterWithEmailAndPassword(
    this.username,
    this.password,
    this.confirmPassword,
    this.email,
    this.name,
    this.avatar,
  );
}

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure(this.error);
}

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterBloc(this.registerUseCase) : super(RegisterInitial()) {
    on<RegisterWithEmailAndPassword>((event, emit) async {
      emit(RegisterLoading());

      var base64Avatar = await event.avatar?.toBase64();
      final result = await registerUseCase.call(RegisterDto(
          username: event.username,
          email: event.email,
          name: event.name,
          password: event.password,
          avatar: base64Avatar));

      result.fold((failure) => emit(RegisterFailure(failure.message)),
          (user) => emit(RegisterSuccess()));
    });
  }
}
