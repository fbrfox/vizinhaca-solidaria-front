import 'package:dartz/dartz.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';
import 'package:vizinhanca_solidaria/login/domain/entities/user.dart';
import 'package:vizinhanca_solidaria/register/domain/entities/register_dto.dart';

abstract class RegisterRepository {
  Future<Either<Failure, User>> register(RegisterDto registerDto);
}
