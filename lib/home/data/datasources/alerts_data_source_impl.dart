import 'package:dio/dio.dart';
import 'package:vizinhanca_solidaria/alert/create/domain/entities/create_alert_dto.dart';
import 'package:vizinhanca_solidaria/core/api/api_connection.dart';
import 'package:vizinhanca_solidaria/core/errors/exceptions.dart';
import 'package:vizinhanca_solidaria/home/data/datasources/alerts_data_source.dart';
import 'package:vizinhanca_solidaria/home/domain/entities/alert.dart';
import 'package:vizinhanca_solidaria/home/domain/entities/alerts_nearby_dto.dart';

class AlertsDataSourceImpl implements AlertsDataSource {
  final ApiConnection apiConnection;

  AlertsDataSourceImpl(this.apiConnection);

  @override
  Future<List<Alert>> getAlerts(AlertsNearbyDto dto) async {
    try {
      return apiConnection.get(
        '/alerts/nearby?${dto.toQueryString()}',
        fromJson: (json) =>
            json.map<Alert>((alert) => Alert.fromJson(alert)).toList(),
      );
    } on DioException catch (e) {
      // Converta DioError para ApiException
      throw ApiException(e.response?.statusCode ?? 500, e.message ?? '');
    }
  }

  @override
  Future<void> createAlert(CreateAlertDto alert) async {
    try {
      return await apiConnection.post('/alerts',
          data: alert.toJson(), fromJson: (_) {});
    } on DioException catch (e) {
      // Converta DioError para ApiException
      throw ApiException(e.response?.statusCode ?? 500, e.message ?? '');
    }
  }
}
