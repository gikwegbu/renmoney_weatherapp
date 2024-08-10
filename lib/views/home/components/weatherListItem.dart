import 'package:renmoney_weatherapp/core/models/cityModel.dart';
import 'package:renmoney_weatherapp/utilities/exportedPackages.dart';

class WeatherListItem extends StatelessWidget {
  const WeatherListItem({
    super.key,
    required this.city,
    required this.onTap,
  });

  final CityModel city;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      style: ListTileStyle.list,
      tileColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: onTap,
      title: labelText(city.city ?? "city name"),
      // subtitle: subtext("${city.adminName} - ${city.country}"),
      subtitle: subtext(city.adminName ?? "state name"),
      trailing: Icon(
        Icons.file_present,
        color: Colors.black.withOpacity(0.6),
      ),
    );
  }
}
