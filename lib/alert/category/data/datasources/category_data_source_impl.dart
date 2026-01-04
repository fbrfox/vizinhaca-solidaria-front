import 'package:dio/dio.dart';
import 'package:vizinhanca_solidaria/alert/category/data/datasources/category_data_source.dart';
import 'package:vizinhanca_solidaria/alert/category/domain/entities/category.dart';
import 'package:vizinhanca_solidaria/core/api/api_connection.dart';
import 'package:vizinhanca_solidaria/core/errors/exceptions.dart';

class CategoryDataSourceImpl extends CategoryDataSource {
  final ApiConnection apiConnection;

  CategoryDataSourceImpl(this.apiConnection);

  @override
  Future<List<Category>> getAll() async {
    try {
      return apiConnection.get(
        '/alerts/categories',
        fromJson: (json) =>
            (json as List).map((e) => Category.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      // Converta DioError para ApiException
      throw ApiException(e.response?.statusCode ?? 500, e.message ?? '');
    }
  }
}
