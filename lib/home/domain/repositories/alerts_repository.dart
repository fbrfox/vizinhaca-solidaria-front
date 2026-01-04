import 'package:dartz/dartz.dart';
import 'package:vizinhanca_solidaria/alert/create/domain/entities/create_alert_dto.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';
import 'package:vizinhanca_solidaria/home/domain/entities/alert.dart';
import 'package:vizinhanca_solidaria/home/domain/entities/alerts_nearby_dto.dart';

abstract class AlertsRepository {
  Future<Either<Failure, List<Alert>>> getAlerts(AlertsNearbyDto dto);
  Future<Either<Failure, void>> createAlert(CreateAlertDto alert);
}
