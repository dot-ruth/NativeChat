import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nativechat/models/settings.dart';
import 'package:theme_provider/theme_provider.dart';
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

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   initialRoute: "/",
    //   routes: {"/": (context) => const Homepage()},
    //   theme: ThemeData(
    //     scaffoldBackgroundColor: darkGreyColor,
    //     appBarTheme: AppBarTheme(
    //       backgroundColor: darkGreyColor,
    //       iconTheme: IconThemeData(
    //         color: Colors.grey[800],
    //       ),
    //     ),
    //     iconTheme: IconThemeData(
    //       color: Colors.grey[500]!,
    //     ),
    //   ),
    // );

    return ThemeProvider(
      saveThemesOnChange: true,
      defaultThemeId: "dark_theme",
      themes: [
        AppTheme(
          id: "light_theme",
          description: "light_theme",
          data: ThemeData(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
            ),
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
          ),
        ),
        AppTheme(
          id: "dark_theme",
          description: "dark_theme",
          data: ThemeData(
            primaryColor: Colors.black,
            scaffoldBackgroundColor: darkGreyColor,
            appBarTheme: AppBarTheme(
              backgroundColor: darkGreyColor,
            ),
            iconTheme: IconThemeData(
              color: Colors.grey[500],
            ),
          ),
        ),
      ],
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            theme: ThemeProvider.themeOf(themeContext).data,
            debugShowCheckedModeBanner: false,
            initialRoute: "/",
            routes: {
              "/": (context) => const Homepage(),
            },
          ),
        ),
      ),
    );
  }
}
