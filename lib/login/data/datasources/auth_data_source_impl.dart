import 'package:dio/dio.dart';
import 'package:vizinhanca_solidaria/core/api/api_connection.dart';
import 'package:vizinhanca_solidaria/core/errors/exceptions.dart';
import 'package:vizinhanca_solidaria/login/data/datasources/auth_data_source.dart';
import 'package:vizinhanca_solidaria/login/domain/entities/login_dto.dart';
import 'package:vizinhanca_solidaria/login/domain/entities/user.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final ApiConnection apiConnection;

  AuthDataSourceImpl(this.apiConnection);

  @override
  Future<User> login(LoginDto loginDto) async {
    try {
      return apiConnection.post(
        '/auth/login',
        data: loginDto.toJson(),
        fromJson: (json) => User.fromJsonWithAddress(json),
      );
    } on DioException catch (e) {
      // Converta DioError para ApiException
      throw ApiException(e.response?.statusCode ?? 500, e.message ?? '');
    }
  }
}
