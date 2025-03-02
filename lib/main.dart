import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nativechat/models/settings.dart';
// import 'package:flutter/services.dart';

import 'pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SettingsAdapter());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var darkGreyColor = Color(0xff0a0a0a);
    // var darkGreyColor = Color(0xff0f0f0f);
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.dark,
    //   ),
    // );

    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.immersive,
    //   overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    // );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {"/": (context) => const Homepage()},
      theme: ThemeData(
        scaffoldBackgroundColor: darkGreyColor,
        appBarTheme: AppBarTheme(
          backgroundColor: darkGreyColor,
          iconTheme: IconThemeData(
            color: Colors.grey[800],
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[500]!,
        ),
      ),
    );
  }
}
