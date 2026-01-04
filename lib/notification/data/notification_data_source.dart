import '../domain/entities/notification.dart';

abstract class NotificationDataSource {
  Future<List<Notification>> getNotifications();
}
