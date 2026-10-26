import 'package:flutter/material.dart';
import '../controllers/app_state_controller.dart';
import '../widgets/destination_card.dart';
import '../services/l10n.dart';
import 'destination_details_screen.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({super.key});

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF121A15) : const Color(0xFFF8FAF8);
    final cardColor = isDark ? const Color(0xFF1A2620) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF263A31);
    final mutedColor = isDark ? Colors.white70 : const Color(0xFF8A9690);

    final destinations = _appState.filteredDestinations;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          L10n.get('popularDestinations', lang),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
        ),
        backgroundColor: cardColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: primary),
            onPressed: () => _showFilterSheet(isDark, cardColor, textColor),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            color: cardColor,
            child: TextField(
              onChanged: _appState.updateSearch,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: L10n.get('searchHint', lang),
                hintStyle: TextStyle(color: mutedColor),
                prefixIcon: Icon(Icons.search_rounded, color: mutedColor),
                filled: true,
                fillColor: isDark ? const Color(0xFF24362D) : const Color(0xFFF0F4F1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: destinations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 48, color: mutedColor),
                        const SizedBox(height: 12),
                        Text(
                          L10n.get('whereToNext', lang),
                          style: TextStyle(
                              color: mutedColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 195,
                    ),
                    itemCount: destinations.length,
                    itemBuilder: (context, index) {
                      final destination = destinations[index];
                      return DestinationCard(
                        destination: destination,
                        showLocation: true,
                        isFavourite: _appState.isFavourite(destination),
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
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(bool isDark, Color cardColor, Color textColor) {
    const primary = Color(0xFF168765);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filter by Category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 12),
              for (final cat in ['All', 'Beach', 'Hills', 'Nature'])
                RadioListTile<String>(
                  value: cat,
                  groupValue: _appState.selectedCategory,
                  activeColor: primary,
                  title: Text(cat, style: TextStyle(color: textColor)),
                  onChanged: (val) {
                    if (val != null) {
                      _appState.selectCategory(val);
                      Navigator.pop(context);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
