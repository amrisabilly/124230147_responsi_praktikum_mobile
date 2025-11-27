import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../controllers/api_controller.dart';
import 'login_screen.dart';
import 'favourite_screen.dart';
import 'detail_screen.dart';
import '../models/data_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = '';
  final AuthService _authService = AuthService();
  final ApiController _apiController = ApiController();
  int _currentIndex = 0;
  List<Restaurant> _searchResults = [];
  bool _isLoading = false;
  String _selectedCategory = 'Semua';

  final List<String> _categories = [
    'Semua',
    'Italia',
    'Modern',
    'Sunda',
    'Jawa',
    'Bali',
  ];

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _fetchRestaurantsByCategory('Semua');
  }

  void _loadUsername() async {
    final String? user = await _authService.getUsername();
    setState(() {
      _username = user ?? 'User';
    });
  }

  void _favourite() {
    setState(() {
      _currentIndex = 1;
    });
  }

  void _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  Future<void> _fetchRestaurantsByCategory(String category) async {
    setState(() {
      _isLoading = true;
      _selectedCategory = category;
    });
    try {
      List<Restaurant> results;
      if (category == 'Semua') {
        results = await _apiController.searchRestaurants('');
      } else {
        results = await _apiController.searchRestaurants(category);
      }
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
    }
  }

  Widget _buildCategoryFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children:
            _categories.map((cat) {
              final bool selected = cat == _selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: selected,
                  selectedColor: Color(0xFF015C92),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (_) => _fetchRestaurantsByCategory(cat),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_searchResults.isEmpty) {
      return Center(child: Text('Restoran tidak ditemukan.'));
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final restaurant = _searchResults[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Image.network(
              'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
              width: 60,
              fit: BoxFit.cover,
            ),
            title: Text(restaurant.name),
            subtitle: Row(
              children: [
                Text('${restaurant.city}'),
                SizedBox(width: 8),
                Icon(Icons.star, color: Colors.amber, size: 16),
                Text('${restaurant.rating}'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => DetailScreen(restaurantId: restaurant.id),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        _buildCategoryFilter(),
        Expanded(child: _buildSearchResults()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF015C92),
        title: Text(
          "Halo, $_username",
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavouriteScreen(),
                ),
              );
            },
            icon: const Icon(Icons.favorite, color: Colors.white),
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: _buildHomeContent(),
    );
  }
}
