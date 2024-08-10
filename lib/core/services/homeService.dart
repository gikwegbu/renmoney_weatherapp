import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:renmoney_weatherapp/core/data/weatherRemoteDataSource.dart';
import 'package:renmoney_weatherapp/core/models/weatherModel.dart';

class HomeService {
  final HomeRepository _homeRepository;
  final log = Logger('Local Storage Service');

  HomeService(this._homeRepository);

  Future<WeatherModel> fetchWeather({
    required double lat,
    required double lon,
  }) async {
    try {
      return await _homeRepository.fetchWeatherData(lat: lat, lon: lon);
    } on DioException catch (e) {
      log.severe("Error message @Fetch Weather ::===> ${e.message}");
      rethrow;
    }
  }
}
