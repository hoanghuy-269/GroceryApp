import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/models/notification.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/screens/favourite_screen.dart';
import 'package:grocery_app/screens/notification_sreen.dart';
import 'package:grocery_app/screens/product_detail_screen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:grocery_app/database/database_provider.dart';

class Home extends StatefulWidget {
  final Function(Product) onAddToCart;

  const Home({super.key, required this.onAddToCart});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> products = [];
  List<Product> favoriteProducts = [];
  List<Notifications> notifications = [];
  String searchQuery = '';
  bool isLoading = true;
  late AppDatabase _database;

  Map<String, dynamic> selectCategory = {"label": "Tất cả", "key": 0};

  final List<Map<String, dynamic>> categories = [
    {"label": "Tất cả", "key": 0},
    {"label": "Đồ Ăn", "key": 1},
    {"label": "Nước Uống", "key": 2},
    {"label": "Mì - Cháo Ăn liền", "key": 3},
    {"label": "Gia vị", "key": 4},
    {"label": "Đồ dùng học tập", "key": 5},
    {"label": "Đồ dùng trong gia đình", "key": 6},
  ];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await DatabaseProvider.database;
    await _loadNotifications();
    await _loadProducts();
  }

  Future<void> _loadNotifications() async {
    final all = await _database.notificationDao.getAllNotifications();
    setState(() {
      notifications = all;
    });
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Product> loadedProducts = [];
      final key = selectCategory["key"] as int;
      if (key == 0) {
        loadedProducts = await _database.productDao.getAllProducts();
      } else {
        loadedProducts = await _database.productDao.getProductByCategory(key);
      }
      setState(() {
        products = loadedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi tải sản phẩm: $e')));
    }
  }

  void _toggleFavorite(Product product) {
    setState(() {
      if (favoriteProducts.contains(product)) {
        favoriteProducts.remove(product);
      } else {
        favoriteProducts.add(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts =
        products
            .where(
              (p) =>
                  p.quantity > 0 &&
                  p.name.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grocery App"),
        actions: [
          IconButton(
            onPressed: () async {
              final updatedFavorites = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => FavoriteScreen(
                        favoriteItems: favoriteProducts,
                        onRemoveFavorite: _toggleFavorite,
                      ),
                ),
              );
              if (updatedFavorites != null) {
                setState(() {
                  favoriteProducts = updatedFavorites;
                });
              }
            },
            icon: const Icon(Icons.favorite),
          ),
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: 0, end: 3),
            badgeContent: Text(
              notifications.length.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            child: IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
                // Không cần làm gì thêm ở đây
              },
              icon: const Icon(Icons.notifications),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03,
        ),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm ...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      categories.map((category) {
                        final isSelected =
                            category['key'] == selectCategory['key'];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  isSelected
                                      ? Colors.green[400]
                                      : Colors.grey[200],
                              foregroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectCategory = category;
                              });
                              _loadProducts();
                            },
                            child: Text(category['label']),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: filteredProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2 / 3.3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ProductCard(
                            product: product,
                            onAddToCart: widget.onAddToCart,
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final Function(Product) onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final double finalPrice =
        product.discount != null && product.discount! > 0
            ? product.price * (1 - product.discount! / 100)
            : product.price;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetail(product: product),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    product.imgURL.isNotEmpty
                        ? Image.file(
                          File(product.imgURL),
                          height: 100,
                          fit: BoxFit.cover,
                        )
                        : Container(
                          height: 100,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, size: 40),
                        ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            if (product.discount != null && product.discount! > 0) ...[
              Text(
                '${product.price.toStringAsFixed(0)} VND',
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                '${finalPrice.toStringAsFixed(0)} VND',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Giảm ${product.discount!.toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.green, fontSize: 12),
              ),
            ] else ...[
              Text(
                '${product.price.toStringAsFixed(0)} VND',
                style: const TextStyle(fontSize: 14),
              ),
            ],
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: const Text(
                  "Thêm vào giỏ",
                  style: TextStyle(fontSize: 14),
                ),
                onPressed: () => onAddToCart(product),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
