import 'package:flutter/material.dart';

import '../controllers/app_state_controller.dart';
import '../models/destination.dart';
import '../services/l10n.dart';
import '../widgets/destination_card.dart';
import '../widgets/section_heading.dart';
import 'destination_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const green = Color(0xFF168765);

  final AppStateController _appState = AppStateController();
  final TextEditingController _searchController = TextEditingController();

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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = _appState.languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF121A15) : const Color(0xFFF8FAF8);
    final textColor = isDark ? Colors.white : const Color(0xFF263A31);
    final mutedColor = isDark ? Colors.white70 : const Color(0xFF8A9690);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(lang, isDark, textColor, mutedColor),
            Expanded(
              child: CustomScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Text(
                          L10n.get('whereToNext', lang),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          L10n.get('findGetaway', lang),
                          style: TextStyle(color: mutedColor, fontSize: 13),
                        ),
                        const SizedBox(height: 20),
                        _buildSearchBar(lang, isDark, textColor, mutedColor),
                        const SizedBox(height: 15),
                        _buildCategories(lang, isDark),
                        const SizedBox(height: 24),
                        SectionHeading(
                          title: L10n.get('popularDestinations', lang),
                          onSeeAll: () => _showAllDestinations(
                            L10n.get('popularDestinations', lang),
                            _appState.filteredDestinations,
                            lang,
                            isDark,
                          ),
                        ),
                        const SizedBox(height: 13),
                        _buildGrid(_appState.popularDestinations, true, lang, mutedColor),
                        const SizedBox(height: 24),
                        SectionHeading(
                          title: L10n.get('exploreMore', lang),
                          onSeeAll: () => _showAllDestinations(
                            L10n.get('exploreMore', lang),
                            _appState.filteredDestinations,
                            lang,
                            isDark,
                          ),
                        ),
                        const SizedBox(height: 13),
                        _buildGrid(_appState.exploreDestinations, false, lang, mutedColor),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(String lang, bool isDark, Color textColor, Color mutedColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F2E26) : const Color(0xFFE7F4ED),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.location_on_rounded, color: green, size: 23),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(L10n.get('appName', lang),
                    style: TextStyle(color: mutedColor, fontSize: 11)),
                const SizedBox(height: 2),
                Text(
                  L10n.get('tagline', lang),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: isDark ? const Color(0xFF1F2E26) : const Color(0xFFF0F4F1),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _showNotifications,
              child: SizedBox(
                width: 38,
                height: 38,
                child: Icon(Icons.notifications_none_rounded,
                    color: isDark ? Colors.white70 : const Color(0xFF40564B), size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(String lang, bool isDark, Color textColor, Color mutedColor) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2E26) : const Color(0xFFF0F4F1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(Icons.search_rounded, color: mutedColor, size: 22),
          const SizedBox(width: 9),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _appState.updateSearch,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: L10n.get('searchHint', lang),
                hintStyle: TextStyle(color: mutedColor, fontSize: 13),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Filter destinations',
            onPressed: () => _showFilterOptions(lang, isDark),
            icon: const Icon(Icons.tune_rounded, color: green, size: 22),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildCategories(String lang, bool isDark) {
    final categories = [
      ('All', L10n.get('all', lang)),
      ('Beach', L10n.get('beach', lang)),
      ('Hills', L10n.get('hills', lang)),
      ('Nature', L10n.get('nature', lang)),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((item) {
          final selected = _appState.selectedCategory == item.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 9),
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () => _appState.selectCategory(item.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                decoration: BoxDecoration(
                  color: selected ? green : (isDark ? const Color(0xFF1F2E26) : const Color(0xFFF0F4F1)),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  item.$2,
                  style: TextStyle(
                    color: selected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF617067)),
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGrid(List<Destination> items, bool showLocation, String lang, Color mutedColor) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off_rounded, size: 38, color: mutedColor),
              const SizedBox(height: 8),
              Text('No destinations found',
                  style: TextStyle(color: mutedColor, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(L10n.get('noFavoritesSubtitle', lang),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: mutedColor, fontSize: 12)),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 15,
          children: items.map((destination) {
            return SizedBox(
              width: width,
              child: DestinationCard(
                destination: destination,
                showLocation: showLocation,
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
                      content: Text(added
                          ? 'Added to favorites ❤️'
                          : 'Removed from favorites'),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showAllDestinations(String title, List<Destination> items, String lang, bool isDark) {
    final sheetBg = isDark ? const Color(0xFF1A2620) : const Color(0xFFF8FAF8);
    final textCol = isDark ? Colors.white : const Color(0xFF263A31);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: SizedBox(
          height: MediaQuery.of(sheetContext).size.height * 0.82,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(title,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: textCol)),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: Icon(Icons.close_rounded, color: textCol),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(child: Text('No destinations found.', style: TextStyle(color: textCol)))
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                        itemCount: items.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 205,
                        ),
                        itemBuilder: (context, index) {
                          final destination = items[index];
                          return DestinationCard(
                            destination: destination,
                            showLocation: true,
                            isFavourite: _appState.isFavourite(destination),
                            onTap: () {
                              Navigator.pop(sheetContext);
                              Navigator.of(this.context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => DestinationDetailsScreen(
                                    destination: destination,
                                  ),
                                ),
                              );
                            },
                            onFavouriteTap: () {
                              final added = _appState.toggleFavourite(destination);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(added
                                      ? 'Added to favorites ❤️'
                                      : 'Removed from favorites'),
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
        ),
      ),
    );
  }

  void _showFilterOptions(String lang, bool isDark) {
    final sheetBg = isDark ? const Color(0xFF1A2620) : Colors.white;
    final textCol = isDark ? Colors.white : const Color(0xFF263A31);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filter destinations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textCol)),
              const SizedBox(height: 12),
              for (final category in ['All', 'Beach', 'Hills', 'Nature'])
                RadioListTile<String>(
                  value: category,
                  groupValue: _appState.selectedCategory,
                  activeColor: green,
                  title: Text(L10n.get(category.toLowerCase(), lang), style: TextStyle(color: textCol)),
                  onChanged: (value) {
                    if (value == null) return;
                    _appState.selectCategory(value);
                    Navigator.pop(sheetContext);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotifications() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1A2620) : Colors.white;
    final textCol = isDark ? Colors.white : const Color(0xFF263A31);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.notifications_none_rounded, size: 45, color: green),
              const SizedBox(height: 12),
              Text('You are all caught up!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textCol)),
              const SizedBox(height: 8),
              Text(
                'Travel updates and booking notifications will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: isDark ? Colors.white70 : const Color(0xFF8A9690), height: 1.5),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
