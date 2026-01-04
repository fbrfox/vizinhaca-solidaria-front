import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vizinhanca_solidaria/alert/create/domain/entities/create_alert_dto.dart';
import 'package:vizinhanca_solidaria/alert/create/domain/usecases/create_alert_usecase.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';
import 'package:vizinhanca_solidaria/core/location/location_manager.dart';
import 'package:vizinhanca_solidaria/core/ui/file_extensions.dart';

abstract class CreateAlertState {}

class CreateAlertInitial extends CreateAlertState {}

class CreateAlertLoading extends CreateAlertState {}

class CreateAlertSuccess extends CreateAlertState {}

class CreateAlertError extends CreateAlertState {
  final String message;
  CreateAlertError(this.message);
}

class UnauthorizerFailureState extends CreateAlertState {
  final String message;
  UnauthorizerFailureState(this.message);
}

abstract class CreateAlertEvent {}

class CreateAlert extends CreateAlertEvent {
  final String description;
  final int categoryId;
  final File image;
  CreateAlert(this.description, this.categoryId, this.image);
}

class CreateAlertBloc extends Bloc<CreateAlertEvent, CreateAlertState> {
  final CreateAlertUsecase createAlertUsecase;
  CreateAlertBloc(this.createAlertUsecase) : super(CreateAlertInitial()) {
    on<CreateAlert>((event, emit) async {
      emit(CreateAlertLoading());
      try {
        var location = await LocationManager.getCurrentPosition();
        var base64 = await event.image.toBase64();

        final result = await createAlertUsecase.execute(CreateAlertDto(
            description: event.description,
            categoryId: event.categoryId,
            lat: location.latitude,
            long: location.longitude,
            image: base64));

        result.fold((failure) {
          if (failure is UnauthorizerFailure) {
            emit(UnauthorizerFailureState('Usuário não autenticado'));
          } else {
            emit(CreateAlertError(failure.message));
          }
        }, (_) => emit(CreateAlertSuccess()));
      } catch (e) {
        emit(CreateAlertError(e.toString()));
      }
    });
  }
}
