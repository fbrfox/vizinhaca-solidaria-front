import 'package:dartz/dartz.dart';
import 'package:vizinhanca_solidaria/core/errors/exceptions.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';
import 'package:vizinhanca_solidaria/login/domain/entities/user.dart';
import 'package:vizinhanca_solidaria/register/data/datasources/register_data_source.dart';
import 'package:vizinhanca_solidaria/register/domain/entities/register_dto.dart';
import 'package:vizinhanca_solidaria/register/domain/repositories/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterDataSource dataSource;

  RegisterRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, User>> register(RegisterDto registerDto) async {
    try {
      final user = await dataSource.register(registerDto);
      return Right(user);
    } on UnauthorizedException {
      return Left(UnauthorizerFailure());
    } on ApiException catch (e) {
      return Left(CustomMessageFailure(e.message));
    }
  }
}
