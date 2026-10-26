import 'package:flutter/material.dart';
import '../controllers/app_state_controller.dart';
import '../widgets/destination_card.dart';
import '../services/l10n.dart';
import 'destination_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
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

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF168765);
    final lang = _appState.languageCode;
    final favorites = _appState.favoriteDestinations;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF121A15) : const Color(0xFFF8FAF8);
    final cardColor = isDark ? const Color(0xFF1A2620) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF263A31);
    final mutedColor = isDark ? Colors.white70 : const Color(0xFF8A9690);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          L10n.get('favorites', lang),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
        ),
        backgroundColor: cardColor,
        elevation: 0,
      ),
      body: favorites.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1F2E26) : const Color(0xFFE7F4ED),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(Icons.favorite_rounded,
                          size: 36, color: primary),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      L10n.get('noFavorites', lang),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      L10n.get('noFavoritesSubtitle', lang),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: mutedColor, fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 195,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final destination = favorites[index];
                return DestinationCard(
                  destination: destination,
                  showLocation: true,
                  isFavourite: true,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => DestinationDetailsScreen(
                        destination: destination,
                      ),
                    ),
                  ),
                  onFavouriteTap: () {
                    final added = _appState.toggleFavourite(destination);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(added ? 'Added to favorites ❤️' : 'Removed from favorites'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
