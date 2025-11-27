class FavouriteController {
  static final List<Map<String, dynamic>> _favourites = [];

  Future<bool> isFavourite(String id) async {
    return _favourites.any((item) => item['id'] == id);
  }

  Future<void> addToFavourite(Map<String, dynamic> restaurant) async {
    if (!await isFavourite(restaurant['id'])) {
      _favourites.add(restaurant);
    }
  }

  Future<void> removeFromFavourite(String id) async {
    _favourites.removeWhere((item) => item['id'] == id);
  }

  Future<List<Map<String, dynamic>>> getAllFavourites() async {
    return _favourites;
  }
}
