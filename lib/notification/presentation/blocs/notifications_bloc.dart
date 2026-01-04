import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';
import 'package:vizinhanca_solidaria/notification/domain/entities/notification.dart';
import 'package:vizinhanca_solidaria/notification/domain/usecases/get_user_notifications_usecases.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsSuccess extends NotificationsState {
  final List<Notification> notifications;
  NotificationsSuccess(this.notifications);
}

class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError(this.message);
}

class UnauthorizerNotificationFailureState extends NotificationsState {
  final String message;
  UnauthorizerNotificationFailureState(this.message);
}

abstract class NotificationsEvent {}

class GetNotifications extends NotificationsEvent {}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetUserNotificationsUsecases getUserNotificationsUsecases;

  NotificationsBloc(this.getUserNotificationsUsecases)
      : super(NotificationsInitial()) {
    on<GetNotifications>((event, emit) async {
      try {
        emit(NotificationsLoading());

        final result = await getUserNotificationsUsecases.call();

        result.fold((failure) {
          if (failure is UnauthorizerFailure) {
            emit(UnauthorizerNotificationFailureState(
                'Usuário não autenticado'));
          } else {
            emit(NotificationsError(failure.message));
          }
        }, (alerts) => emit(NotificationsSuccess(alerts)));
      } catch (e) {
        emit(NotificationsError(e.toString()));
      }
    });
  }
}
