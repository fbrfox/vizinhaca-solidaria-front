import 'package:dartz/dartz.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';
import 'package:vizinhanca_solidaria/notification/domain/entities/notification.dart';
import 'package:vizinhanca_solidaria/notification/domain/repositories/notification_repository.dart';

class GetUserNotificationsUsecases {
  final NotificationRepository _notificationRepository;

  GetUserNotificationsUsecases(this._notificationRepository);

  Future<Either<Failure, List<Notification>>> call() async {
    return _notificationRepository.getNotifications();
  }
}
