import 'package:flutter/material.dart';

import 'pages/homepage.dart';

void main() {
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
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.dark,
    //   ),
    // );

    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.edgeToEdge,
    //   overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    // );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {"/": (context) => const Homepage()},
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff0f0f0f),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff0f0f0f),
        ),
        canvasColor: Color(0xff0f0f0f),
        iconTheme: IconThemeData(
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
