import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:renmoney_weatherapp/config/dependencies.dart';
import 'package:renmoney_weatherapp/config/locale_storage.dart';
import 'package:renmoney_weatherapp/core/viewModel/homeController.dart';
import 'package:renmoney_weatherapp/utilities/constants.dart';
import 'package:renmoney_weatherapp/views/home/homeView.dart';
import 'package:provider/provider.dart';

void main() async{
  await LocalStorageService.initializeDb();
  setUpLocator();
  _setupLogging();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeController>(
          create: (_) => locator.get<HomeController>(),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
         builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        title: appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeView(),
      ),
    );
  }
}



void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) async {
    var log =
        '${rec.level.name}: ${rec.time} <:::::> [${rec.loggerName}] ${rec.sequenceNumber} : ${rec.message}';
    debugPrint(log);
  });
}

void logError(String code, String? message) {
  if (message != null) {
    debugPrint('Error: $code\nError Message: $message');
  } else {
    debugPrint('Error: $code');
  }
}