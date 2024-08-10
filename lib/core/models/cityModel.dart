// To parse this JSON data, do
//
//     final cityModel = cityModelFromJson(jsonString);

import 'dart:convert';

List<CityModel> cityModelFromJson(String str) =>
    List<CityModel>.from(json.decode(str).map((x) => CityModel.fromJson(x)));

String cityModelToJson(List<CityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityModel {
  final String? city;
  final String? lat;
  final String? lng;
  final String? country;
  final String? iso2;
  final String? adminName;
  final String? capital;
  final String? population;
  final String? populationProper;

  CityModel({
    this.city,
    this.lat,
    this.lng,
    this.country,
    this.iso2,
    this.adminName,
    this.capital,
    this.population,
    this.populationProper,
  });

  CityModel copyWith({
    String? city,
    String? lat,
    String? lng,
    String? country,
    String? iso2,
    String? adminName,
    String? capital,
    String? population,
    String? populationProper,
  }) =>
      CityModel(
        city: city ?? this.city,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        country: country ?? this.country,
        iso2: iso2 ?? this.iso2,
        adminName: adminName ?? this.adminName,
        capital: capital ?? this.capital,
        population: population ?? this.population,
        populationProper: populationProper ?? this.populationProper,
      );

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        city: json["city"],
        lat: json["lat"],
        lng: json["lng"],
        country: json["country"],
        iso2: json["iso2"],
        adminName: json["admin_name"],
        capital: json["capital"],
        population: json["population"],
        populationProper: json["population_proper"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "lat": lat,
        "lng": lng,
        "country": country,
        "iso2": iso2,
        "admin_name": adminName,
        "capital": capital,
        "population": population,
        "population_proper": populationProper,
      };

  List<CityModel> fromList(List items) {
    if (items.isNotEmpty) {
      return items.map((e) => CityModel.fromJson(e)).toList();
    }
    return [];
  }
}
