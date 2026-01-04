import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vizinhanca_solidaria/address/domain/entities/create_address_dto.dart';
import 'package:vizinhanca_solidaria/address/domain/usecases/create_address_usecase.dart';

abstract class AddressRegisterEvent {}

class RegisterAddress extends AddressRegisterEvent {
  final CreateAddressDto address;
  RegisterAddress(this.address);
}

abstract class AddressRegisterState {}

class AddressRegisterInitial extends AddressRegisterState {}

class AddressRegisterLoading extends AddressRegisterState {}

class AddressRegisterSuccess extends AddressRegisterState {}

class AddressRegisterFailure extends AddressRegisterState {
  final String error;
  AddressRegisterFailure(this.error);
}

class AddressRegisterBloc
    extends Bloc<AddressRegisterEvent, AddressRegisterState> {
  final CreateAddressUseCase createAddressUseCase;

  AddressRegisterBloc(this.createAddressUseCase)
      : super(AddressRegisterInitial()) {
    on<RegisterAddress>((event, emit) async {
      emit(AddressRegisterLoading());
      final result = await createAddressUseCase(event.address);
      result.fold(
        (failure) => emit(AddressRegisterFailure(failure.toString())),
        (_) => emit(AddressRegisterSuccess()),
      );
    });
  }
}
