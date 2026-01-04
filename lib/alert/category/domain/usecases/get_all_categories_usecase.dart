import 'package:dartz/dartz.dart';
import 'package:vizinhanca_solidaria/alert/category/domain/entities/category.dart';
import 'package:vizinhanca_solidaria/alert/category/domain/repositories/category_repository.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';

class GetAllCategoriesUsecase {
  final CategoryRepository _categoryRepository;

  GetAllCategoriesUsecase(this._categoryRepository);

  Future<Either<Failure, List<Category>>> call() async {
    return await _categoryRepository.getAll();
  }
}
