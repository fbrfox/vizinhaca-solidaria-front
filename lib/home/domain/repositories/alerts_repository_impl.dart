import 'package:dartz/dartz.dart';
import 'package:vizinhanca_solidaria/alert/create/domain/entities/create_alert_dto.dart';
import 'package:vizinhanca_solidaria/core/errors/exceptions.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';
import 'package:vizinhanca_solidaria/home/data/datasources/alerts_data_source.dart';
import 'package:vizinhanca_solidaria/home/domain/entities/alert.dart';
import 'package:vizinhanca_solidaria/home/domain/entities/alerts_nearby_dto.dart';
import 'package:vizinhanca_solidaria/home/domain/repositories/alerts_repository.dart';

class AlertsRepositoryImpl implements AlertsRepository {
  final AlertsDataSource dataSource;

  AlertsRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Alert>>> getAlerts(AlertsNearbyDto dto) async {
    try {
      final alerts = await dataSource.getAlerts(dto);
      return Right(alerts);
    } on UnauthorizedException {
      return Left(UnauthorizerFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createAlert(CreateAlertDto alert) async {
    try {
      await dataSource.createAlert(alert);
      return Right(null);
    } on UnauthorizedException {
      return Left(UnauthorizerFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
