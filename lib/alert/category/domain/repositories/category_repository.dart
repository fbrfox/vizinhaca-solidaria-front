import 'package:dartz/dartz.dart';
import 'package:vizinhanca_solidaria/alert/category/domain/entities/category.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getAll();
}
