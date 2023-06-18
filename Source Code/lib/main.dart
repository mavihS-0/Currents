import 'package:currents/screens/home.dart';
import 'package:currents/screens/splashScreen.dart';
import 'package:currents/util/constants.dart';
import 'package:currents/util/navBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currents',
      //declaring Theme Data
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(background: BgColor),
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      //splash screen when opening app
      home: SplashPage(),

    );
  }
}

