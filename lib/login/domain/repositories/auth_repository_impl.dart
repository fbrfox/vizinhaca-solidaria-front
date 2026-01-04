import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vizinhanca_solidaria/core/errors/exceptions.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';
import 'package:vizinhanca_solidaria/login/data/datasources/auth_data_source.dart';
import 'package:vizinhanca_solidaria/login/domain/entities/login_dto.dart';
import 'package:vizinhanca_solidaria/login/domain/entities/user.dart';
import 'package:vizinhanca_solidaria/login/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;
  final FlutterSecureStorage storage;

  AuthRepositoryImpl(this.dataSource, this.storage);

  @override
  Future<Either<Failure, User>> login(LoginDto loginDto) async {
    try {
      final user = await dataSource.login(loginDto);
      await storage.write(key: 'access_token', value: user.token);
      await storage.write(key: 'user_name', value: user.name);
      await storage.write(key: 'user_id', value: user.id.toString());
      await storage.write(key: 'user_email', value: user.email);
      await storage.write(key: 'remember', value: loginDto.remember.toString());
      return Right(user);
    } on UnauthorizedException {
      return Left(UnauthorizerFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on UnknownException {
      return Left(ServerFailure());
    }
  }
}
