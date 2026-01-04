import 'package:dio/dio.dart';
import 'package:vizinhanca_solidaria/core/api/api_connection.dart';
import 'package:vizinhanca_solidaria/core/errors/exceptions.dart';
import 'package:vizinhanca_solidaria/login/domain/entities/user.dart';
import 'package:vizinhanca_solidaria/register/data/datasources/register_data_source.dart';
import 'package:vizinhanca_solidaria/register/domain/entities/register_dto.dart';

class RegisterDataSourceImpl implements RegisterDataSource {
  final ApiConnection apiConnection;

  RegisterDataSourceImpl(this.apiConnection);

  @override
  Future<User> register(RegisterDto regiterDto) async {
    try {
      return apiConnection.post(
        '/users',
        data: regiterDto.toJson(),
        fromJson: (json) => User.fromJson(json),
      );
    } on DioException catch (e) {
      // Converta DioError para ApiException
      throw ApiException(e.response?.statusCode ?? 500, e.message ?? '');
    }
  }
}
