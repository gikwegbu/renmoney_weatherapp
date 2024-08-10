import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:renmoney_weatherapp/config/env.config.dart';
import 'package:renmoney_weatherapp/config/locale_storage.dart';
import 'package:renmoney_weatherapp/core/data/weatherRemoteDataSource.dart';
import 'package:renmoney_weatherapp/core/services/homeService.dart';
import 'package:renmoney_weatherapp/core/viewModel/homeController.dart';

final locator = GetIt.instance;

void setUpLocator() {
  locator.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  locator.registerSingleton<LocalStorageService>(
      LocalStorageService(locator.get<FlutterSecureStorage>()));

  locator.registerSingleton<Dio>(Dio());

  //repository
  locator.registerSingleton<HomeRepository>(
    HomeRepository(
      dioConfig(),
    ),
  );

// Service
  locator.registerSingleton<HomeService>(
    HomeService(locator<HomeRepository>()),
  );

  // controller
  locator.registerSingleton<HomeController>(
    HomeController(locator<HomeService>()),
  );

  // locator.registerLazySingleton<WeatherRemoteDataSource>(WeatherServiceImpl());
}

Dio dioConfig() {
  Dio dio = locator.get<Dio>();

  dio.options.baseUrl = baseUrl;
  dio.options.connectTimeout = const Duration(milliseconds: 20000);
  dio.options.sendTimeout = const Duration(milliseconds: 10000);

  return dio;
}
