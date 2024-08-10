import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';
import 'package:renmoney_weatherapp/config/dependencies.dart';
import 'package:renmoney_weatherapp/config/locale_storage.dart';
import 'package:renmoney_weatherapp/core/models/cityModel.dart';
import 'package:renmoney_weatherapp/core/models/weatherModel.dart';
import 'package:renmoney_weatherapp/core/services/homeService.dart';
import 'package:renmoney_weatherapp/utilities/constants.dart';
import 'package:renmoney_weatherapp/utilities/utils.dart';

class HomeController extends ChangeNotifier {
  final HomeService _homeService;
  final log = Logger('Local Storage Service');
  final localStorageService = locator.get<LocalStorageService>();

  HomeController(this._homeService);

  // Variables
  bool _isFetching = false;
  List<CityModel> _cityList = <CityModel>[];
  List<CityModel> _filteredCityList = <CityModel>[];
  List<CityModel> _savedCityList = <CityModel>[];
  WeatherModel _currentWeather = WeatherModel();

  // Getters
  bool get isFetching => _isFetching;
  List<CityModel> get cityList => _cityList;
  List<CityModel> get filteredCityList => _filteredCityList;
  WeatherModel get currentWeather => _currentWeather;
  // List<CityModel> get savedCityList => _savedCityList;

  List<CityModel> get savedCityList {
    // Future<List<CityModel>> get savedCityList async {
    var cities = localStorageService.getJsonData(savedCitiesDb);
    // localStorageService.remove(savedCitiesDb);
    // var cities = await localStorageService.getSecureJson(savedCitiesDb);
    _savedCityList = (cities != null)
        ? CityModel().fromList(cities!)
        : [
            _cityList[0],
            _cityList[1],
            _cityList[2],
          ];
    return _savedCityList;
  }

  // Setters

  void setCityList(List<CityModel> cities) {
    _cityList = cities;
    _filteredCityList = cities;
    notifyListeners();
  }

  void setFilteredCityList(String text) {
    _filteredCityList = text.isEmpty
        ? _cityList
        : _cityList
            .where((element) =>
                (element.city!.toLowerCase().contains(text.toLowerCase())) ||
                (element.adminName!.toLowerCase().contains(text.toLowerCase())))
            .toList();
    notifyListeners();
  }

  void resetFilteredCityList() {
    _filteredCityList = _cityList;
    notifyListeners();
  }

  void resetCurrentWeather() {
    _currentWeather = WeatherModel();
    notifyListeners();
  }

  void setIsFetching(bool status) {
    _isFetching = status;
    notifyListeners();
  }

  void setCurrentlyViewedWeather(WeatherModel weather) {
    _currentWeather = weather;
    notifyListeners();
  }

  void saveUnsaveCity(CityModel city, {bool isDeviceLoc = false}) async {
    int index =
        _savedCityList.indexWhere((element) => element.city == city.city);
    if (canSaveCity(city)) {
      showSuccess(message: "Added ${city.city} to your favorite List");
      _savedCityList.insert(0, city);
    } else if (constantLocations.contains(city.city?.toLowerCase())) {
      showText(message: "Oops!!!, You can't Unsave ${city.city}");
      return;
    } else if (isDeviceLoc) {
      // This wedges situations where the device location is being added and removed (from the code in the else block)
      return;
    } else {
      showText(message: "Removed ${city.city} to your favorite List");
      _savedCityList.removeAt(index);
    }

    // await localStorageService.saveSecureJson(savedCitiesDb, _savedCityList);
    await localStorageService.saveJsonData(savedCitiesDb, _savedCityList);
    // await savedCityList;
    notifyListeners();
  }

  // This check to see if the city is saved already
  bool canSaveCity(CityModel city) =>
      _savedCityList.indexWhere((element) => element.city == city.city) == -1;

  setCome() {}

  Future<void> addDeviceLocationToSavedCities({
    required Position position,
    required Placemark place,
  }) async {
    final deviceCity = CityModel(
      city: place.name ?? 'Current City',
      lat: "${position.latitude}",
      lng: "${position.longitude}",
      country: place.country ?? "Current Country",
      iso2: place.isoCountryCode,
      adminName: place.administrativeArea,
      capital: place.administrativeArea,
      population: place.administrativeArea,
      populationProper: place.administrativeArea,
    );
    saveUnsaveCity(deviceCity, isDeviceLoc: true);
    notifyListeners();
    return;
  }

  // Functions

  Future<void> loadCities() async {
    final cities = await readCityJson();
    setCityList(cities);
  }

  Future<bool> fetchWeather({
    required double lat,
    required double lon,
  }) async {
    setIsFetching(true);

    try {
      setIsFetching(false);
      final res = await _homeService.fetchWeather(
        lat: lat,
        lon: lon,
      );

      setCurrentlyViewedWeather(res);
      return true;
    } on DioException catch (e) {
      showError(message: e.response?.data["message"]);
      setIsFetching(false);
      return false;
    } finally {
      setIsFetching(false);
    }
  }
}
