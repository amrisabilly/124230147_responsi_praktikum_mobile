import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/data_model.dart';

class ApiController {
  Future<List<Restaurant>> searchRestaurants(String query) async {
    final url = 'https://restaurant-api.dicoding.dev/search?q=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final result = SearchResult.fromJson(json.decode(response.body));
      return result.restaurants;
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  Future<RestaurantDetail> fetchRestaurantDetail(String id) async {
    final url = 'https://restaurant-api.dicoding.dev/detail/$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }
}
