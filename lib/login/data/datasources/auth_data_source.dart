import 'package:vizinhanca_solidaria/login/domain/entities/login_dto.dart';
import 'package:vizinhanca_solidaria/login/domain/entities/user.dart';

abstract class AuthDataSource {
  Future<User> login(LoginDto loginDto);
}
