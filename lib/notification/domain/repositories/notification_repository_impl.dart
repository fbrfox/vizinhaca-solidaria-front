import 'package:dartz/dartz.dart';
import 'package:vizinhanca_solidaria/core/errors/exceptions.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';
import 'package:vizinhanca_solidaria/notification/data/notification_data_source.dart';
import 'package:vizinhanca_solidaria/notification/domain/entities/notification.dart';
import 'package:vizinhanca_solidaria/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource notificationDataSource;

  NotificationRepositoryImpl(this.notificationDataSource);

  @override
  Future<Either<Failure, List<Notification>>> getNotifications() async {
    try {
      final notifications = await notificationDataSource.getNotifications();
      return Right(notifications);
    } on UnauthorizedException {
      return Left(UnauthorizerFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
