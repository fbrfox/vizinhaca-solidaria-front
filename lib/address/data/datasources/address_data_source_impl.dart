import 'package:dio/dio.dart';
import 'package:vizinhanca_solidaria/address/data/datasources/address_data_source.dart';
import 'package:vizinhanca_solidaria/address/domain/entities/address.dart';
import 'package:vizinhanca_solidaria/address/domain/entities/create_address_dto.dart';
import 'package:vizinhanca_solidaria/core/api/api_connection.dart';
import 'package:vizinhanca_solidaria/core/errors/exceptions.dart';

class AddressDataSourceImpl implements AddressDataSource {
  final ApiConnection apiConnection;

  AddressDataSourceImpl(
    this.apiConnection,
  );

  @override
  Future<Address> register(CreateAddressDto addressDto) {
    try {
      return apiConnection.post(
        '/address',
        data: addressDto.toJson(),
        fromJson: (json) => Address.fromJson(json),
      );
    } on DioException catch (e) {
      // Converta DioError para ApiException
      throw ApiException(e.response?.statusCode ?? 500, e.message ?? '');
    }
  }
}
