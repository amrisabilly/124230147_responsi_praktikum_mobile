class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}

class SearchResult {
  final List<Restaurant> restaurants;

  SearchResult({required this.restaurants});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    var list = json['restaurants'] as List;
    List<Restaurant> restaurants =
        list.map((i) => Restaurant.fromJson(i)).toList();
    return SearchResult(restaurants: restaurants);
  }
}

class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final String address;
  final double rating;
  final List<String> categories;
  final List<String> foods;
  final List<String> drinks;
  final List<Map<String, dynamic>> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.address,
    required this.rating,
    required this.categories,
    required this.foods,
    required this.drinks,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    final r = json['restaurant'];
    return RestaurantDetail(
      id: r['id'],
      name: r['name'],
      description: r['description'],
      pictureId: r['pictureId'],
      city: r['city'],
      address: r['address'],
      rating: (r['rating'] as num).toDouble(),
      categories: List<String>.from(r['categories'].map((c) => c['name'])),
      foods: List<String>.from(r['menus']['foods'].map((f) => f['name'])),
      drinks: List<String>.from(r['menus']['drinks'].map((d) => d['name'])),
      customerReviews: List<Map<String, dynamic>>.from(r['customerReviews']),
    );
  }
}
