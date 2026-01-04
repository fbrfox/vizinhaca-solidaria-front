import 'package:dartz/dartz.dart';
import 'package:vizinhanca_solidaria/address/domain/entities/address.dart';
import 'package:vizinhanca_solidaria/address/domain/entities/create_address_dto.dart';
import 'package:vizinhanca_solidaria/address/domain/repositories/address_repository.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';

class CreateAddressUseCase {
  final AddressRepository addressRepository;

  CreateAddressUseCase(this.addressRepository);

  Future<Either<Failure, Address>> call(CreateAddressDto dto) async {
    return await addressRepository.register(dto);
  }
}
