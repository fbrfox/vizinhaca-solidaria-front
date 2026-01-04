import 'package:vizinhanca_solidaria/address/domain/entities/address.dart';
import 'package:vizinhanca_solidaria/address/domain/entities/create_address_dto.dart';

abstract class AddressDataSource {
  Future<Address> register(CreateAddressDto addressDto);
}
