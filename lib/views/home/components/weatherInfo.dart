import 'package:renmoney_weatherapp/utilities/exportedPackages.dart';

class WeatherInfo extends StatelessWidget {
  const WeatherInfo({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        style: ListTileStyle.list,
        tileColor: Colors.grey.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: labelText(title),
        subtitle: subtext(subtitle),
      ),
    );
  }
}
