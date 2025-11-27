import 'package:flutter/material.dart';
import '../controllers/api_controller.dart';
import '../models/data_model.dart';
import '../controllers/favourite_controller.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;
  const DetailScreen({super.key, required this.restaurantId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<RestaurantDetail> _futureDetail;
  final ApiController _apiController = ApiController();
  final FavouriteController _favouriteController = FavouriteController();
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    _futureDetail = _apiController.fetchRestaurantDetail(widget.restaurantId);
    _checkFavourite();
  }

  Future<void> _checkFavourite() async {
    bool fav = await _favouriteController.isFavourite(widget.restaurantId);
    setState(() {
      _isFavourite = fav;
    });
  }

  Future<void> _toggleFavourite(RestaurantDetail detail) async {
    if (_isFavourite) {
      await _favouriteController.removeFromFavourite(detail.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${detail.name} dihapus dari favourite'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      await _favouriteController.addToFavourite({
        'id': detail.id,
        'name': detail.name,
        'pictureId': detail.pictureId,
        'city': detail.city,
        'rating': detail.rating,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${detail.name} ditambahkan ke favourite'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
    _checkFavourite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Restoran"),
        actions: [
          FutureBuilder<RestaurantDetail>(
            future: _futureDetail,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return IconButton(
                  onPressed: () => _toggleFavourite(snapshot.data!),
                  icon: Icon(
                    _isFavourite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavourite ? Colors.orange : null,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: FutureBuilder<RestaurantDetail>(
        future: _futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          final r = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://restaurant-api.dicoding.dev/images/medium/${r.pictureId}',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (ctx, _, __) =>
                          Container(height: 200, color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('${r.address}, ${r.city}'),
                          Spacer(),
                          Chip(
                            label: Text(r.rating.toString()),
                            avatar: Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children:
                            r.categories
                                .map((cat) => Chip(label: Text(cat)))
                                .toList(),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Deskripsi:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(r.description),
                      SizedBox(height: 12),
                      Text(
                        "Menu Makanan:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 8,
                        children:
                            r.foods
                                .map((food) => Chip(label: Text(food)))
                                .toList(),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Menu Minuman:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 8,
                        children:
                            r.drinks
                                .map((drink) => Chip(label: Text(drink)))
                                .toList(),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Customer Reviews:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...r.customerReviews.map(
                        (rev) => ListTile(
                          title: Text(rev['name']),
                          subtitle: Text(rev['review']),
                          trailing: Text(rev['date']),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
