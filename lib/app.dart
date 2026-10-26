import 'package:flutter/material.dart';
import 'controllers/app_state_controller.dart';
import 'screens/splash_screen.dart';

class TourNestApp extends StatefulWidget {
  const TourNestApp({super.key});

  @override
  State<TourNestApp> createState() => _TourNestAppState();
}

class _TourNestAppState extends State<TourNestApp> {
  final AppStateController _appState = AppStateController();

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onChanged);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _appState.removeListener(_onChanged);
    super.dispose();
  }

  static const primary = Color(0xFF168765);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TourNest',
      debugShowCheckedModeBanner: false,
      themeMode: _appState.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
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
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121A15),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A2620),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}
