import 'package:vizinhanca_solidaria/alert/create/domain/entities/create_alert_dto.dart';
import 'package:vizinhanca_solidaria/home/domain/entities/alert.dart';
import 'package:vizinhanca_solidaria/home/domain/entities/alerts_nearby_dto.dart';

abstract class AlertsDataSource {
  Future<List<Alert>> getAlerts(AlertsNearbyDto dto);
  Future<void> createAlert(CreateAlertDto alert);
}
