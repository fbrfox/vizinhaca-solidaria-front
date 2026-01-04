import 'package:dartz/dartz.dart';
import 'package:vizinhanca_solidaria/alert/category/data/datasources/category_data_source.dart';
import 'package:vizinhanca_solidaria/alert/category/domain/entities/category.dart';
import 'package:vizinhanca_solidaria/alert/category/domain/repositories/category_repository.dart';
import 'package:vizinhanca_solidaria/core/errors/exceptions.dart';
import 'package:vizinhanca_solidaria/core/errors/failures.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  final CategoryDataSource categoryDataSource;

  CategoryRepositoryImpl(this.categoryDataSource);

  @override
  Future<Either<Failure, List<Category>>> getAll() async {
    try {
      final categories = await categoryDataSource.getAll();
      return Right(categories);
    } on UnauthorizedException {
      return Left(UnauthorizerFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
