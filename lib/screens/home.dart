import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/screens/favourite_screen.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/screens/product_detail_screen.dart';

class Home extends StatefulWidget {
  final Function(Product) onAddToCart;

  const Home({super.key, required this.onAddToCart});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> products = [];
  List<Product> favoriteProducts = [];
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
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    // Nếu muốn thêm sản phẩm mẫu từ file path thật, sửa đường dẫn trong _addSampleProducts
    //await _addSampleProducts();
    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Product> loadedProducts = [];
      final categoryKey = selectCategory["key"] as int;
      if (categoryKey == 0) {
        loadedProducts = await _database.productDao.getAllProducts();
      } else {
        loadedProducts = await _database.productDao.getProductByCategory(
          categoryKey,
        );
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

  Future<void> _addSampleProducts() async {
    final sampleProducts = <Product>[
      Product(
        id: 4,
        name: 'Mì tôm Hảo Hảo',
        price: 7,
        imgURL: '/storage/emulated/0/Pictures/mi_haohao.png',
        description: 'Mì ăn liền vị chua cay, ngon tuyệt cho mọi bữa ăn nhanh.',
        quantity: 200,
        loai: 3,
        status: "Còn hàng",
        lastUpdated: DateTime.now(),
      ),
    ];
    for (final product in sampleProducts) {
      await _database.productDao.insertProduct(product);
      print('Đường dẫn ảnh: ${product.imgURL}');
    }
  }

  void _addToCart(Product product) {
    widget.onAddToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} đã được thêm vào giỏ hàng')),
    );
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
              (p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()),
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
                  builder: (context) {
                    return FavoriteScreen(
                      favoriteItems: favoriteProducts,
                      onRemoveFavorite: _toggleFavorite,
                    );
                  },
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
                            onFavorite: _toggleFavorite,
                            isFavorite: favoriteProducts.contains(product),
                            onAddToCart: _addToCart,
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
  final Function(Product) onFavorite;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetail(product: product),
                    ),
                  );
                },
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.file(
                    File(product.imgURL),
                    fit: BoxFit.cover,
                    height: 100,
                    width: double.infinity,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => onFavorite(product),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('${product.price.toStringAsFixed(3)} VND'),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => onAddToCart(product),
              child: const Text('Thêm vào giỏ hàng'),
            ),
          ),
        ],
      ),
    );
  }
}
