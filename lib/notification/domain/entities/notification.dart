import 'package:vizinhanca_solidaria/home/domain/entities/alert.dart';

class Notification {
  final int id;
  final String title;
  final DateTime createdAt;
  final Alert alert;

  Notification(
      {required this.id,
      required this.title,
      required this.createdAt,
      required this.alert});

  factory Notification.fromJson(Map<String, dynamic> json) {
    var notification = json;
    print("Notification: $notification");
    Map<String, dynamic> alert = notification['alert'];
    print(alert);

    return Notification(
      id: notification['id'],
      title: notification['title'],
      createdAt: DateTime.parse(notification['createdAt']),
      alert: Alert.fromJson(alert),
    );
  }
}
