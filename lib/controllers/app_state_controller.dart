import 'package:flutter/material.dart';
import '../data/destination_data.dart';
import '../models/destination.dart';
import '../models/booking_item.dart';

class AppStateController extends ChangeNotifier {
  // Singleton pattern for easy global access across screens
  static final AppStateController _instance = AppStateController._internal();
  factory AppStateController() => _instance;
  AppStateController._internal();

  String selectedCategory = 'All';
  String searchQuery = '';
  final Set<String> favourites = <String>{};
  
  final List<BookingItem> bookings = [
    BookingItem(
      id: 'b1',
      destinationName: 'Cox\'s Bazar Sea Beach',
      location: 'Cox\'s Bazar, Chittagong',
      imageUrl: 'https://images.unsplash.com/photo-1589182337358-2fabedd73fc6?auto=format&fit=crop&q=80&w=800',
      travellers: 2,
      date: '15/11/2026',
      estimatedCost: 'BDT 12,000',
      status: 'Confirmed',
      createdAt: '26 Oct 2026',
    ),
    BookingItem(
      id: 'b2',
      destinationName: 'Sajek Valley',
      location: 'Rangamati, Chittagong',
      imageUrl: 'https://images.unsplash.com/photo-1621689724103-120033008a08?auto=format&fit=crop&q=80&w=800',
      travellers: 4,
      date: '02/12/2026',
      estimatedCost: 'BDT 18,000',
      status: 'Pending',
      createdAt: '26 Oct 2026',
    ),
  ];

  ThemeMode themeMode = ThemeMode.light;
  String languageCode = 'en';

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setLanguage(String code) {
    languageCode = code;
    notifyListeners();
  }

  List<Destination> get filteredDestinations {
    final query = searchQuery.trim().toLowerCase();
    return destinations.where((destination) {
      final categoryMatch =
          selectedCategory == 'All' || destination.category == selectedCategory;
      final searchMatch = query.isEmpty ||
          destination.name.toLowerCase().contains(query) ||
          destination.location.toLowerCase().contains(query) ||
          destination.category.toLowerCase().contains(query);
      return categoryMatch && searchMatch;
    }).toList();
  }

  List<Destination> get popularDestinations =>
      filteredDestinations.take(4).toList();

  List<Destination> get exploreDestinations =>
      filteredDestinations.skip(4).toList();

  List<Destination> get favoriteDestinations =>
      destinations.where((d) => favourites.contains(d.id)).toList();

  void updateSearch(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void selectCategory(String value) {
    selectedCategory = value;
    notifyListeners();
  }

  bool toggleFavourite(Destination destination) {
    final added = favourites.add(destination.id);
    if (!added) {
      favourites.remove(destination.id);
    }
    notifyListeners();
    return added;
  }

  bool isFavourite(Destination destination) =>
      favourites.contains(destination.id);

  void addBooking(BookingItem item) {
    bookings.insert(0, item);
    notifyListeners();
  }

  void removeBooking(String id) {
    bookings.removeWhere((b) => b.id == id);
    notifyListeners();
  }
}
