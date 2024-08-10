// Various State checkers

// ignore_for_file: use_build_context_synchronously

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:renmoney_weatherapp/core/models/cityModel.dart';
import 'package:renmoney_weatherapp/core/viewModel/homeController.dart';

isEmpty(String? val) {
  return (val == null) || (val.trim().isEmpty);
}

isNotEmpty(String? val) {
  return !isEmpty(val);
}

isNumber(String val) {
  return num.tryParse(val) != null;
}

isObjectEmpty(dynamic val) {
  if (val is Map) return val.isEmpty;
  if (val is List) return val.isEmpty;
  if (val is String) return isEmpty(val);
  return (val == null);
}

// Notification BotToast
enum _AlertType { error, success, message }

showNotification(
    {required String message,
    required Duration duration,
    GestureTapCallback? onTap}) {
  BotToast.showSimpleNotification(
      title: message, duration: duration, onTap: onTap);
}

showText({required String message, Duration? duration}) {
  _showAlert(message, _AlertType.message, d: duration);
}

_showAlert(String message, _AlertType alert, {Duration? d}) {
  var bgColor = Colors.black.withOpacity(.9);
  var duration = d ?? const Duration(seconds: 2);

  switch (alert) {
    case _AlertType.error:
      bgColor = Colors.red;
      duration = d ?? const Duration(seconds: 3);
      break;
    case _AlertType.success:
      bgColor = Colors.green;
      break;
    default:
      break;
  }
  BotToast.showText(
    text: message,
    contentColor: bgColor,
    contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    textStyle: const TextStyle(fontSize: 13.0, color: Colors.white),
    duration: duration,
  );
}

showSuccess({required String message}) {
  _showAlert(message, _AlertType.success);
}

showError({required String message, Duration? duration}) {
  _showAlert(message, _AlertType.error, d: duration);
}

String errorMessageToString(List<String>? message) {
  return isObjectEmpty(message)
      ? 'Sever error occurred. Please try again later'
      : message!.join("\n");
}

closeKeypad(BuildContext context) {
  //
}

ySpace({double? height = 10}) => SizedBox(height: height);
xSpace({double? width = 10}) => SizedBox(width: width);

void customShowBottomSheet({
  required BuildContext ctx,
  required Widget child,
}) {
  showModalBottomSheet(
    context: ctx,
    backgroundColor: Colors.white,
    elevation: 10,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    builder: (BuildContext context) {
      // UDE : SizedBox instead of Container for whitespaces
      return child;
    },
  );
}

closeKeyPad(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

Widget divider({double? height = 20}) => Divider(
      height: height,
      color: Colors.black,
    );

Future<List<CityModel>> readCityJson() async {
  final String response = await rootBundle.loadString('assets/cityList.json');
  return cityModelFromJson(response);
}

safeNavigate(Function callback) {
  Future.microtask(() => callback());
}

Future<bool> determinePosition(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    showError(
        message:
            "Oops!!! You denied the location permission forever, sadly, we can't get your current location for your weather data report");
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  // Call the HomeCtrl function to fetch the weather data of the current Location and add it to the Saved List...
  final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  final place = await _getAddressFromLatLng(position);
  context
      .read<HomeController>()
      .addDeviceLocationToSavedCities(position: position, place: place);
  return true;
}

Future<Placemark> _getAddressFromLatLng(Position position) async {
  final List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );
  Placemark place = placemarks[0];

  return place;
}
