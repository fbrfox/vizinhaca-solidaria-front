import 'package:dartz/dartz.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';

import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<Notification>>> getNotifications();
}
