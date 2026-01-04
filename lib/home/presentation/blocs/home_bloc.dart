import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';
import 'package:vizinhanca_solidaria/core/location/location_manager.dart';
import 'package:vizinhanca_solidaria/home/domain/entities/alert.dart';
import 'package:vizinhanca_solidaria/home/domain/entities/alerts_nearby_dto.dart';
import 'package:vizinhanca_solidaria/home/domain/usecases/get_alerts_nearby_usecase.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeGetAlertsSuccess extends HomeState {
  final List<Alert> alerts;
  final Position? currentPosition;
  HomeGetAlertsSuccess(this.alerts, this.currentPosition);
}

class HomeGetAlertsError extends HomeState {
  final String message;
  HomeGetAlertsError(this.message);
}

class UnauthorizerFailureState extends HomeState {
  final String message;
  UnauthorizerFailureState(this.message);
}

abstract class HomeEvent {}

class HomeGetAlerts extends HomeEvent {}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  GetAlertsNearbyUsecase getAlertsNearbyUsecase;

  HomeBloc(this.getAlertsNearbyUsecase) : super(HomeInitial()) {
    on<HomeGetAlerts>((event, emit) async {
      try {
        final position = await LocationManager.getCurrentPosition();
        emit(HomeLoading());
        final result = await getAlertsNearbyUsecase(
            AlertsNearbyDto(lat: position.latitude, long: position.longitude));

        result.fold((failure) {
          if (failure is UnauthorizerFailure) {
            emit(UnauthorizerFailureState('Usuário não autenticado'));
          } else {
            emit(HomeGetAlertsError('Erro inesperado'));
          }
        }, (alerts) => emit(HomeGetAlertsSuccess(alerts, position)));
      } catch (e) {
        print(e);
        emit(HomeGetAlertsError(e.toString()));
      }
    });
  }
}
