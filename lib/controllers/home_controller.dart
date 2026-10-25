import 'package:flutter/foundation.dart';
import '../data/destination_data.dart';
import '../models/destination.dart';

class HomeController extends ChangeNotifier {
  String selectedCategory = 'All';
  String searchQuery = '';
  final Set<String> favourites = <String>{};

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
      filteredDestinations.take(2).toList();

  List<Destination> get exploreDestinations =>
      filteredDestinations.skip(2).toList();

  void updateSearch(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void selectCategory(String value) {
    selectedCategory = value;
    notifyListeners();
  }

  void toggleFavourite(Destination destination) {
    if (!favourites.add(destination.id)) {
      favourites.remove(destination.id);
    }
    notifyListeners();
  }

  bool isFavourite(Destination destination) =>
      favourites.contains(destination.id);
}
