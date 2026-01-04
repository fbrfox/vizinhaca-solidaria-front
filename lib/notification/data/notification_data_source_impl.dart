import 'package:dio/dio.dart';
import 'package:vizinhanca_solidaria/core/api/api_connection.dart';
import 'package:vizinhanca_solidaria/core/errors/exceptions.dart';
import 'package:vizinhanca_solidaria/notification/data/notification_data_source.dart';

import '../domain/entities/notification.dart';

class NotificationDataSourceImpl implements NotificationDataSource {
  final ApiConnection apiConnection;

  NotificationDataSourceImpl(this.apiConnection);

  @override
  Future<List<Notification>> getNotifications() {
    try {
      return apiConnection.get(
        '/notifications',
        fromJson: (json) {
          return (json as List).map((e) => Notification.fromJson(e)).toList();
        },
      );
    } on DioException catch (e) {
      // Converta DioError para ApiException
      throw ApiException(e.response?.statusCode ?? 500, e.message ?? '');
    }
  }
}
