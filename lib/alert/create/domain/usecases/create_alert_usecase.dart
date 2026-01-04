import 'package:dartz/dartz.dart';
import 'package:vizinhanca_solidaria/alert/create/domain/entities/create_alert_dto.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';
import 'package:vizinhanca_solidaria/home/domain/repositories/alerts_repository.dart';

class CreateAlertUsecase {
  final AlertsRepository _alertRepository;

  CreateAlertUsecase(this._alertRepository);

  Future<Either<Failure, void>> execute(CreateAlertDto alert) async {
    return await _alertRepository.createAlert(alert);
  }
}
