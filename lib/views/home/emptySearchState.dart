import 'package:renmoney_weatherapp/utilities/exportedPackages.dart';

class EmptySearchState extends StatelessWidget {
  const EmptySearchState({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 50),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black.withOpacity(0.3),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(5, 5),
            )
          ]),
      child: Column(
        children: [
          const Icon(
            Icons.search,
            size: 80,
            color: Colors.grey,
          ),
          ySpace(),
          labelText(
            "No Results",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          ySpace(height: 5),
          subtext("The searched location '$text' is not avialable"),
        ],
      ),
    );
  }
}
