import 'package:flutter/material.dart';
import 'package:renmoney_weatherapp/core/models/cityModel.dart';
import 'package:renmoney_weatherapp/utilities/texts.dart';

class SavedWeatherCard extends StatelessWidget {
  const SavedWeatherCard({
    super.key,
    required this.city,
    required this.onTap,
  });

  final GestureTapCallback onTap;
  final CityModel city;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Card(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.7),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelText("${city.city}"),
                subtext(
                  "${city.adminName}",
                  fontSize: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
