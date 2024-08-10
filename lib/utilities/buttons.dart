import 'package:renmoney_weatherapp/utilities/exportedPackages.dart';

class CustomBtn extends StatelessWidget {
  const CustomBtn({
    super.key,
    required this.btnTxt,
    required this.onTap,
    this.isLoading = false,
  });

  final String btnTxt;
  final GestureTapCallback onTap;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(5, 5),
            )
          ],
        ),
        child: isLoading
            ? const CircularProgressIndicator.adaptive()
            : labelText(btnTxt, textAlign: TextAlign.center),
      ),
    );
  }
}
