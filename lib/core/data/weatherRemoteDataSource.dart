import 'package:dio/dio.dart';
import 'package:renmoney_weatherapp/config/env.config.dart';
import 'package:renmoney_weatherapp/core/models/weatherModel.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> fetchWeatherData({
    required double lat,
    required double lon,
  });
}

class WeatherApi {
  static fetchWeatherData({
    required double lat,
    required double lon,
  }) =>
      "$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey";
}

class HomeRepository extends WeatherRemoteDataSource {
  final Dio dio;
  HomeRepository(this.dio);

  @override
  Future<WeatherModel> fetchWeatherData({
    required double lat,
    required double lon,
  }) async {
    try {
      final res =
          await dio.get(WeatherApi.fetchWeatherData(lat: lat, lon: lon));
      return WeatherModel.fromJson(res.data as Map<String, dynamic>);
    } on Exception catch (e) {
      throw Exception("Something went wrong");
    } catch (e) {
      rethrow;
    }
  }
}
