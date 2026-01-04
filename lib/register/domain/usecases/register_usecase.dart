import 'package:dartz/dartz.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';
import 'package:vizinhanca_solidaria/login/domain/entities/user.dart';
import 'package:vizinhanca_solidaria/register/domain/entities/register_dto.dart';
import 'package:vizinhanca_solidaria/register/domain/repositories/register_repository.dart';

class RegisterUseCase {
  final RegisterRepository repository;
  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call(RegisterDto registerDto) async {
    return await repository.register(registerDto);
  }
}
