import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shree_vimal_mobile_dhule/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var prefs = await SharedPreferences.getInstance();
  prefs.getString('license');
  prefs.getString('uname');
  prefs.getString('pswd');

  runApp(
      // DevicePreview(
      // enabled: true,
      // builder: (context) =>
      MaterialApp(
    // useInheritedMediaQuery: true,
    theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          errorStyle: GoogleFonts.manrope(
            fontSize: 15,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))))),
    scrollBehavior: const MaterialScrollBehavior()
        .copyWith(dragDevices: {...PointerDeviceKind.values}),
    debugShowCheckedModeBanner: false,
    locale: const Locale('en', 'IN'),
    localizationsDelegates: fu.FluentLocalizations.localizationsDelegates,
    home:
    
     const SplashScreen(),
  ));
  // ));
}
