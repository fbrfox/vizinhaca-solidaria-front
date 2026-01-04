import 'package:dartz/dartz.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';
import 'package:vizinhanca_solidaria/home/domain/entities/alert.dart';
import 'package:vizinhanca_solidaria/home/domain/entities/alerts_nearby_dto.dart';
import 'package:vizinhanca_solidaria/home/domain/repositories/alerts_repository.dart';

class GetAlertsNearbyUsecase {
  final AlertsRepository alertRepository;

  GetAlertsNearbyUsecase(this.alertRepository);

  Future<Either<Failure, List<Alert>>> call(AlertsNearbyDto dto) async {
    return await alertRepository.getAlerts(dto);
  }
}
