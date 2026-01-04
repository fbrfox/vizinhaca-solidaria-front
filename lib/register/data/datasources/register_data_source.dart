import 'package:vizinhanca_solidaria/login/domain/entities/user.dart';
import 'package:vizinhanca_solidaria/register/domain/entities/register_dto.dart';

abstract class RegisterDataSource {
  Future<User> register(RegisterDto regiterDto);
}
