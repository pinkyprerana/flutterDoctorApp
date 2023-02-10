import 'package:doctor_app/data/datasource/remote/dio/dio_client.dart';
import 'package:doctor_app/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:doctor_app/data/repository/auth_repo.dart';
import 'package:doctor_app/data/repository/data_repo.dart';
import 'package:doctor_app/data/repository/find_search_repo.dart';
import 'package:doctor_app/data/repository/health_record_repo.dart';
import 'package:doctor_app/data/repository/splash_repo.dart';
import 'package:doctor_app/provider/auth_provider.dart';
import 'package:doctor_app/provider/data_provider.dart';
import 'package:doctor_app/provider/find_search_provider.dart';
import 'package:doctor_app/provider/health_record_provider.dart';
import 'package:doctor_app/provider/splash_provider.dart';
import 'package:doctor_app/routes_networking/app_routes.dart';
import 'package:doctor_app/util/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // register Singleton :: register with repository
  sl.registerLazySingleton(() => DioClient(AppRoutes.BASE_URL, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => FindSearchRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => HealthRecordRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => DataRepo(sharedPreferences: sl(), dioClient: sl()));


  // register Factory :: register with provider
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo:sl()));
  sl.registerFactory(() => FindSearchProvider(findSearchRepo:sl()));
  sl.registerFactory(() => HealthRecordProvider(healthRecordRepo:sl()));
  sl.registerFactory(() => DataProvider(dataRepo:sl()));


  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}