import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:renmoney_weatherapp/config/dependencies.dart';
import 'package:renmoney_weatherapp/core/data/weatherRemoteDataSource.dart';
import 'package:mockito/annotations.dart';

import 'weatherRemoteDataSource_test.mocks.dart';

class HomeRepoTest extends Mock implements HomeRepository {}

@GenerateMocks([HomeRepoTest])
void main() {
  late WeatherRemoteDataSource dataSource;

  setUpAll(() {
    setUpLocator(); // calling the locator for dependencies
    dataSource = MockHomeRepoTest();
  });

  group("Testing the DataSource", () {
    test("description", () {
      const model = "";

      // when(dataSource.fetchWeatherData()).thenAnswer((_) async {
      //   return model;
      // });
    });
  });
}
