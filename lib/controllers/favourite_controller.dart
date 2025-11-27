import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavouriteController {
  static List<Map<String, dynamic>> _favourites = [];

  FavouriteController() {
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final favString = prefs.getString('favourites');
    if (favString != null) {
      final List favList = jsonDecode(favString);
      _favourites = favList.map((e) => Map<String, dynamic>.from(e)).toList();
    }
  }

  Future<void> _saveFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('favourites', jsonEncode(_favourites));
  }

  Future<bool> isFavourite(String id) async {
    await _loadFavourites();
    return _favourites.any((item) => item['id'] == id);
  }

  Future<void> addToFavourite(Map<String, dynamic> restaurant) async {
    await _loadFavourites();
    if (!await isFavourite(restaurant['id'])) {
      _favourites.add(restaurant);
      await _saveFavourites();
    }
  }

  Future<void> removeFromFavourite(String id) async {
    await _loadFavourites();
    _favourites.removeWhere((item) => item['id'] == id);
    await _saveFavourites();
  }

  Future<List<Map<String, dynamic>>> getAllFavourites() async {
    await _loadFavourites();
    return _favourites;
  }
}
