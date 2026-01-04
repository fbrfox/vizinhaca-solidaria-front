import '../../domain/entities/category.dart';

abstract class CategoryDataSource {
  Future<List<Category>> getAll();
}
