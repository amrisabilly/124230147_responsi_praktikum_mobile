import 'package:flutter/material.dart';
import '../controllers/favourite_controller.dart';
import 'detail_screen.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final FavouriteController _favouriteController = FavouriteController();
  List<Map<String, dynamic>> _favourites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    final favourites = await _favouriteController.getAllFavourites();
    setState(() {
      _favourites = favourites;
      _isLoading = false;
    });
  }

  Future<void> _removeFromFavourite(String id, String name) async {
    await _favouriteController.removeFromFavourite(id);
    _loadFavourites();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name dihapus dari favourite'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF015C92),
        title: const Text('Favourite', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // kembali ke HomeScreen
          },
        ),
        elevation: 4,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _favourites.isEmpty
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada favourite',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _favourites.length,
                itemBuilder: (context, index) {
                  final item = _favourites[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://restaurant-api.dicoding.dev/images/small/${item['pictureId']}',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (ctx, _, __) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image),
                              ),
                        ),
                      ),
                      title: Text(
                        item['name'] ?? 'No Name',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(item['city'] ?? 'Unknown'),
                          const SizedBox(width: 16),
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(item['rating']?.toString() ?? '0'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _removeFromFavourite(
                            item['id'],
                            item['name'] ?? 'Restoran',
                          );
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    DetailScreen(restaurantId: item['id']),
                          ),
                        ).then((_) => _loadFavourites());
                      },
                    ),
                  );
                },
              ),
    );
  }
}
