import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class TourNestApp extends StatelessWidget {
  const TourNestApp({super.key});

  static const primary = Color(0xFF168765);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TourNest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAF8),
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF263A31),
          elevation: 0,
          centerTitle: false,
        ),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}
