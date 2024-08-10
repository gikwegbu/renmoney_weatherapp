import 'package:flutter_test/flutter_test.dart';
import 'package:renmoney_weatherapp/config/dependencies.dart';
import 'package:renmoney_weatherapp/core/data/weatherRemoteDataSource.dart';
import 'package:renmoney_weatherapp/core/viewModel/homeController.dart';
import 'package:mockito/mockito.dart';

void main() {
  late WeatherRemoteDataSource dataSource;
  late HomeController homeCtrl;

  setUpAll(() {
    setUpLocator(); // calling the locator for dependencies
    // dataSource = locator.get<MockWeatherRemoteDataSource>();
    dataSource = locator.get<HomeRepository>();
    homeCtrl = locator.get<HomeController>();
  });

  group("Testing the Home View Model", () {
    test("description", () {
      const model = "";

      // when(dataSource.fetchWeatherData()).thenAnswer((_) async {
      //   return  model;
      // });
    });
  });
}
