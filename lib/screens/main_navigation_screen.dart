import 'package:flutter/material.dart';
import '../controllers/app_state_controller.dart';
import '../services/l10n.dart';
import 'home_screen.dart';
import 'popular_screen.dart';
import 'favorites_screen.dart';
import 'bookings_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
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

  final List<Widget> _screens = const [
    HomeScreen(),
    PopularScreen(),
    FavoritesScreen(),
    BookingsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF168765);
    final lang = _appState.languageCode;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: primary.withAlpha(35),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.bold, color: primary);
            }
            return const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF75837A));
          }),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          elevation: 8,
          height: 68,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded, color: primary),
              label: L10n.get('home', lang),
            ),
            NavigationDestination(
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: const Icon(Icons.explore_rounded, color: primary),
              label: L10n.get('popular', lang),
            ),
            NavigationDestination(
              icon: const Icon(Icons.favorite_border_rounded),
              selectedIcon: const Icon(Icons.favorite_rounded, color: Colors.redAccent),
              label: L10n.get('favorites', lang),
            ),
            NavigationDestination(
              icon: const Icon(Icons.bookmark_outline_rounded),
              selectedIcon: const Icon(Icons.bookmark_rounded, color: primary),
              label: L10n.get('bookings', lang),
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings_rounded, color: primary),
              label: L10n.get('settings', lang),
            ),
          ],
        ),
      ),
    );
  }
}
