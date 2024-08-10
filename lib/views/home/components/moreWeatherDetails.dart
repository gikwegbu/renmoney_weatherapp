import 'package:provider/provider.dart';
import 'package:renmoney_weatherapp/config/dependencies.dart';
import 'package:renmoney_weatherapp/core/models/cityModel.dart';
import 'package:renmoney_weatherapp/core/viewModel/homeController.dart';
import 'package:renmoney_weatherapp/utilities/buttons.dart';
import 'package:renmoney_weatherapp/utilities/exportedPackages.dart';
import 'package:renmoney_weatherapp/views/home/components/weatherInfo.dart';

class MoreWeatherDetails extends StatefulWidget {
  const MoreWeatherDetails({
    super.key,
    required this.city,
  });

  final CityModel city;

  @override
  State<MoreWeatherDetails> createState() => _MoreWeatherDetailsState();
}

class _MoreWeatherDetailsState extends State<MoreWeatherDetails> {
  late HomeController homeCtrl;
  late CityModel city;
  @override
  void initState() {
    homeCtrl = locator.get<HomeController>();
    city = widget.city;
    safeNavigate(() => fetchCityWeatherDetails());
    super.initState();
  }

  void fetchCityWeatherDetails() {
    safeNavigate(
      () async {
        homeCtrl.resetCurrentWeather();
        final res = await homeCtrl.fetchWeather(
          lat: double.parse("${city.lat}"),
          lon: double.parse("${city.lng}"),
        );
        if (!res && mounted) {
          // Means an error occured, hence the data wasn't fetched
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      width: double.infinity,
      child: Consumer<HomeController>(
        builder: (context, hCtrl, _) {
          if (hCtrl.isFetching || isObjectEmpty(hCtrl.currentWeather.base)) {
            // Shimmer...
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          // Normally, an empty state should be shown here if the result is null, but based on the User Story, the user will be forced back to select another city

          final currentWeather = hCtrl.currentWeather;
          bool canSaveCity = hCtrl.canSaveCity(city);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: labelText(
                      "${city.city} - ${city.adminName}",
                      fontSize: 20,
                    ),
                  ),
                  GestureDetector(
                    onTap: saveUnsaveCity,
                    child: Chip(
                      side: BorderSide(
                        color: canSaveCity
                            ? Colors.green.withOpacity(0.6)
                            : Colors.red,
                      ),
                      label: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 5,
                        children: [
                          Icon(
                            canSaveCity
                                ? Icons.add
                                : Icons.delete_forever_outlined,
                            color: canSaveCity
                                ? Colors.green.withOpacity(0.6)
                                : Colors.red,
                          ),
                          subtext(
                            canSaveCity ? "Save" : "Unsave",
                            color: canSaveCity ? Colors.green : Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              divider(height: 40),

              // Other weather things here...
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    WeatherInfo(
                      title: "${currentWeather.weather?.first.main}",
                      subtitle: "${currentWeather.weather?.first.description}",
                    ),
                    WeatherInfo(
                      title: "Main",
                      subtitle:
                          "temp: ${currentWeather.main?.temp}F, pressure: ${currentWeather.main?.pressure}, humidity: ${currentWeather.main?.humidity}, sea level: ${currentWeather.main?.seaLevel}",
                    ),
                    WeatherInfo(
                      title: "Wind",
                      subtitle:
                          "speed: ${currentWeather.wind?.speed}, deg: ${currentWeather.wind?.deg}, gust: ${currentWeather.wind?.gust}",
                    ),
                    WeatherInfo(
                      title: "System",
                      subtitle:
                          "Sunrise: ${currentWeather.sys?.sunrise}, Sunset: ${currentWeather.sys?.sunset}",
                    ),
                    ySpace(),
                    CustomBtn(
                      btnTxt: "Refresh Data",
                      onTap: fetchCityWeatherDetails,
                      isLoading: hCtrl.isFetching,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void saveUnsaveCity() {
    homeCtrl.saveUnsaveCity(city);
  }
}
