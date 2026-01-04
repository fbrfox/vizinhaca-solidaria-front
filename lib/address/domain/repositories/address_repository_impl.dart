import 'package:dartz/dartz.dart';
import 'package:vizinhanca_solidaria/address/data/datasources/address_data_source.dart';
import 'package:vizinhanca_solidaria/address/domain/entities/address.dart';
import 'package:vizinhanca_solidaria/address/domain/entities/create_address_dto.dart';
import 'package:vizinhanca_solidaria/address/domain/repositories/address_repository.dart';
import 'package:vizinhanca_solidaria/core/errors/exceptions.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressDataSource addressDataSource;

  AddressRepositoryImpl(
    this.addressDataSource,
  );

  @override
  Future<Either<Failure, Address>> register(CreateAddressDto addressDto) async {
    try {
      final address = await addressDataSource.register(addressDto);
      return Right(address);
    } on UnauthorizedException {
      return Left(UnauthorizerFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
