import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:vizinhanca_solidaria/address/data/datasources/address_data_source.dart';
import 'package:vizinhanca_solidaria/address/data/datasources/address_data_source_impl.dart';
import 'package:vizinhanca_solidaria/address/domain/repositories/address_repository.dart';
import 'package:vizinhanca_solidaria/address/domain/repositories/address_repository_impl.dart';
import 'package:vizinhanca_solidaria/address/domain/usecases/create_address_usecase.dart';
import 'package:vizinhanca_solidaria/address/presentation/blocs/address_register_bloc.dart';
import 'package:vizinhanca_solidaria/alert/category/data/datasources/category_data_source.dart';
import 'package:vizinhanca_solidaria/alert/category/data/datasources/category_data_source_impl.dart';
import 'package:vizinhanca_solidaria/alert/category/domain/repositories/category_repository.dart';
import 'package:vizinhanca_solidaria/alert/category/domain/repositories/category_repository_impl.dart';
import 'package:vizinhanca_solidaria/alert/category/domain/usecases/get_all_categories_usecase.dart';
import 'package:vizinhanca_solidaria/alert/category/presentation/blocs/create_category_alert_bloc.dart';
import 'package:vizinhanca_solidaria/alert/create/domain/usecases/create_alert_usecase.dart';
import 'package:vizinhanca_solidaria/alert/create/presentation/blocs/create_alert_bloc.dart';
import 'package:vizinhanca_solidaria/core/api/api_connection.dart';
import 'package:vizinhanca_solidaria/core/api/auth_interceptor.dart';
import 'package:vizinhanca_solidaria/home/data/datasources/alerts_data_source.dart';
import 'package:vizinhanca_solidaria/home/data/datasources/alerts_data_source_impl.dart';
import 'package:vizinhanca_solidaria/home/domain/repositories/alerts_repository.dart';
import 'package:vizinhanca_solidaria/home/domain/repositories/alerts_repository_impl.dart';
import 'package:vizinhanca_solidaria/home/domain/usecases/get_alerts_nearby_usecase.dart';
import 'package:vizinhanca_solidaria/home/presentation/blocs/home_bloc.dart';
import 'package:vizinhanca_solidaria/login/data/datasources/auth_data_source.dart';
import 'package:vizinhanca_solidaria/login/data/datasources/auth_data_source_impl.dart';
import 'package:vizinhanca_solidaria/login/domain/repositories/auth_repository.dart';
import 'package:vizinhanca_solidaria/login/domain/repositories/auth_repository_impl.dart';
import 'package:vizinhanca_solidaria/login/domain/usecases/login_usecase.dart';
import 'package:vizinhanca_solidaria/login/presentation/blocs/login_bloc.dart';
import 'package:vizinhanca_solidaria/notification/data/notification_data_source.dart';
import 'package:vizinhanca_solidaria/notification/data/notification_data_source_impl.dart';
import 'package:vizinhanca_solidaria/notification/domain/repositories/notification_repository.dart';
import 'package:vizinhanca_solidaria/notification/domain/repositories/notification_repository_impl.dart';
import 'package:vizinhanca_solidaria/notification/domain/usecases/get_user_notifications_usecases.dart';
import 'package:vizinhanca_solidaria/notification/presentation/blocs/notifications_bloc.dart';
import 'package:vizinhanca_solidaria/register/data/datasources/register_data_source.dart';
import 'package:vizinhanca_solidaria/register/data/datasources/register_data_source_impl.dart';
import 'package:vizinhanca_solidaria/register/domain/repositories/register_repository.dart';
import 'package:vizinhanca_solidaria/register/domain/repositories/register_repository_impl.dart';
import 'package:vizinhanca_solidaria/register/domain/usecases/register_usecase.dart';
import 'package:vizinhanca_solidaria/register/presentation/blocs/register_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  configApi();

  // Blocs
  sl.registerFactory(() => LoginBloc(sl()));
  sl.registerFactory(() => RegisterBloc(sl()));
  sl.registerFactory(() => AddressRegisterBloc(sl()));
  sl.registerFactory(() => HomeBloc(sl()));
  sl.registerFactory(() => CreateCategoryAlertBloc(sl()));
  sl.registerFactory(() => CreateAlertBloc(sl()));
  sl.registerFactory(() => NotificationsBloc(sl()));

  sl.registerLazySingleton(() => FlutterSecureStorage());
  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => CreateAddressUseCase(sl()));
  sl.registerLazySingleton(() => GetAlertsNearbyUsecase(sl()));
  sl.registerLazySingleton(() => GetAllCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => CreateAlertUsecase(sl()));
  sl.registerLazySingleton(() => GetUserNotificationsUsecases(sl()));

  // Repositories

  sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(sl()));

  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));

  sl.registerLazySingleton<AlertsRepository>(() => AlertsRepositoryImpl(sl()));

  sl.registerLazySingleton<AddressRepository>(
      () => AddressRepositoryImpl(sl()));

  sl.registerLazySingleton<RegisterRepository>(
      () => RegisterRepositoryImpl(sl()));

  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(sl()));
  // Data sources
  sl.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl(sl()));

  sl.registerLazySingleton<AlertsDataSource>(() => AlertsDataSourceImpl(sl()));

  sl.registerLazySingleton<RegisterDataSource>(
      () => RegisterDataSourceImpl(sl()));

  sl.registerLazySingleton<AddressDataSource>(
      () => AddressDataSourceImpl(sl()));

  sl.registerLazySingleton<CategoryDataSource>(
      () => CategoryDataSourceImpl(sl()));

  sl.registerLazySingleton<NotificationDataSource>(
      () => NotificationDataSourceImpl(sl()));
}

void configApi() {
  String apiUrl = dotenv.env['API_URL'] ?? '';

  final dio = Dio(
    BaseOptions(
      baseUrl: apiUrl, // Substitua pela URL da sua API
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer ', // Substitua $token pelo token real
      },
      validateStatus: (int? status) {
        return status != null;
        // return status != null && status >= 200 && status < 300;
      },
    ),
  );

  // Adicione interceptors, se necessário
  dio.interceptors.add(
    InterceptorsWrapper(onResponse: (response, handler) {
      print(response.toString());

      final status = response.statusCode;
      final isValid = status != null && status >= 200 && status < 300;
      if (!isValid) {
        throw DioException.badResponse(
          statusCode: status!,
          requestOptions: response.requestOptions,
          response: response,
        );
      }
      handler.next(response);
    }),
  );

  dio.interceptors.add(AuthInterceptor(FlutterSecureStorage()));

  sl.registerLazySingleton(() => ApiConnection(dio));
}
