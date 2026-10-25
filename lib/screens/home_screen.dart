import 'package:flutter/material.dart';

import '../controllers/home_controller.dart';
import '../models/destination.dart';
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
  static const muted = Color(0xFF8A9690);

  final HomeController _controller = HomeController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: CustomScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const Text(
                          'Where to next?',
                          style: TextStyle(
                            color: Color(0xFF263A31),
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Find your perfect getaway.',
                          style: TextStyle(color: muted, fontSize: 13),
                        ),
                        const SizedBox(height: 20),
                        _buildSearchBar(),
                        const SizedBox(height: 15),
                        _buildCategories(),
                        const SizedBox(height: 24),
                        SectionHeading(
                          title: 'Popular Destinations',
                          onSeeAll: () => _showAllDestinations(
                            'Popular Destinations',
                            _controller.filteredDestinations,
                          ),
                        ),
                        const SizedBox(height: 13),
                        _buildGrid(_controller.popularDestinations, true),
                        const SizedBox(height: 24),
                        SectionHeading(
                          title: 'Explore More',
                          onSeeAll: () => _showAllDestinations(
                            'Explore Destinations',
                            _controller.filteredDestinations,
                          ),
                        ),
                        const SizedBox(height: 13),
                        _buildGrid(_controller.exploreDestinations, false),
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

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F4ED),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.location_on_rounded, color: green, size: 23),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Discover destinations',
                    style: TextStyle(color: muted, fontSize: 11)),
                SizedBox(height: 2),
                Text(
                  'Explore Bangladesh',
                  style: TextStyle(
                    color: Color(0xFF233A30),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: const Color(0xFFF0F4F1),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _showNotifications,
              child: const SizedBox(
                width: 38,
                height: 38,
                child: Icon(Icons.notifications_none_rounded,
                    color: Color(0xFF40564B), size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search_rounded, color: muted, size: 22),
          const SizedBox(width: 9),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _controller.updateSearch,
              decoration: const InputDecoration(
                hintText: 'Search destinations...',
                hintStyle: TextStyle(color: Color(0xFF9AA69F), fontSize: 13),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Filter destinations',
            onPressed: _showFilterOptions,
            icon: const Icon(Icons.tune_rounded, color: green, size: 22),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    const categories = [
      ('All', 'All'),
      ('Beach', '🏖️ Beach'),
      ('Hills', '⛰️ Hills'),
      ('Nature', '🌳 Nature'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((item) {
          final selected = _controller.selectedCategory == item.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 9),
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () => _controller.selectCategory(item.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                decoration: BoxDecoration(
                  color: selected ? green : const Color(0xFFF0F4F1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  item.$2,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF617067),
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

  Widget _buildGrid(List<Destination> items, bool showLocation) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off_rounded, size: 38, color: muted),
              SizedBox(height: 8),
              Text('No destinations found',
                  style: TextStyle(color: muted, fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text('Try another name or category.',
                  style: TextStyle(color: muted, fontSize: 12)),
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
                isFavourite: _controller.isFavourite(destination),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => DestinationDetailsScreen(
                      destination: destination,
                    ),
                  ),
                ),
                onFavouriteTap: () =>
                    _controller.toggleFavourite(destination),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showAllDestinations(String title, List<Destination> items) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF8FAF8),
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
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text('No destinations found.'))
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
                            isFavourite: _controller.isFavourite(destination),
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
                            onFavouriteTap: () =>
                                _controller.toggleFavourite(destination),
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

  void _showFilterOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
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
              const Text('Filter destinations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              for (final category in ['All', 'Beach', 'Hills', 'Nature'])
                RadioListTile<String>(
                  value: category,
                  groupValue: _controller.selectedCategory,
                  activeColor: green,
                  title: Text(category),
                  onChanged: (value) {
                    if (value == null) return;
                    _controller.selectCategory(value);
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
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications_none_rounded, size: 45, color: green),
              SizedBox(height: 12),
              Text('You are all caught up!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                'Travel updates and booking notifications will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted, height: 1.5),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
