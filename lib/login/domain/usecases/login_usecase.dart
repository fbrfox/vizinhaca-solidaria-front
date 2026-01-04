import 'package:dartz/dartz.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';
import 'package:vizinhanca_solidaria/login/domain/entities/login_dto.dart';
import 'package:vizinhanca_solidaria/login/domain/entities/user.dart';
import 'package:vizinhanca_solidaria/login/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call(LoginDto loginDto) async {
    return await repository.login(loginDto);
  }
}
