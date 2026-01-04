import 'package:dartz/dartz.dart';
import 'package:vizinhanca_solidaria/address/domain/entities/address.dart';
import 'package:vizinhanca_solidaria/address/domain/entities/create_address_dto.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';

abstract class AddressRepository {
  Future<Either<Failure, Address>> register(CreateAddressDto addressDto);
}
