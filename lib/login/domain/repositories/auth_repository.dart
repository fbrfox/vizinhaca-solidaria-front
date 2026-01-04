import 'package:vizinhanca_solidaria/core/errors/failures.dart';
import 'package:vizinhanca_solidaria/login/domain/entities/login_dto.dart';
import 'package:vizinhanca_solidaria/login/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(LoginDto loginDto);
}
