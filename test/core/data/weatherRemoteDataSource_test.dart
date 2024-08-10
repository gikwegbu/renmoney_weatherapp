import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:renmoney_weatherapp/core/data/weatherRemoteDataSource.dart';
import 'package:mockito/annotations.dart';
import 'package:renmoney_weatherapp/core/models/weatherModel.dart';

import 'weatherRemoteDataSource_test.mocks.dart';

class HomeRepoTest extends Mock implements HomeRepository {}

@GenerateMocks([HomeRepoTest])
void main() {
  late final WeatherRemoteDataSource dataSource;

  setUpAll(() {
    dataSource = MockHomeRepoTest();
  });

  group("Testing the DataSource", () {
    test("Fetching and confirming we are receiving the same data", () async {
      final model = WeatherModel(
        coord: Coord(lat: 0, lon: 0),
      );

      when(dataSource.fetchWeatherData(lat: 0.0, lon: 0.0))
          .thenAnswer((_) async {
        return model;
      });

      final res = await dataSource.fetchWeatherData(lat: 0, lon: 0);

      expect(res.coord?.lat, model.coord?.lat);
    });
  });
}
