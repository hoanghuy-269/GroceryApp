import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/screens/cartscreen.dart'; // Import màn hình giỏ hàng
import 'package:grocery_app/screens/favourite_screen.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/models/ProductCart .dart'; 

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> products = [];
  List<Product> favoriteProducts = [];
  List<Product> cartProducts = []; // Danh sách sản phẩm trong giỏ hàng
  String searchQuery = '';
  bool isLoading = true;
  late AppDatabase _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    await _addSampleProducts();
    _loadProducts();
  }

  Future<void> _addSampleProducts() async {
    final sampleProducts = [
      Product(
        name: 'Bánh Oreo',
        price: 20000,
        imgURL: 'assets/images/doan_banhoreo.png',
        description: 'Sữa tươi nguyên chất.',
        quantity: 1, // Khởi tạo số lượng sản phẩm
      ),
      Product(
        name: 'Cocacola',
        price: 10000,
        imgURL: 'assets/images/doan_banhoreo.png',
        description: 'Bánh mì tươi ngon.',
        quantity: 1, // Khởi tạo số lượng sản phẩm
      ),
      Product(
        name: 'Red Bull',
        price: 30000,
        imgURL: 'assets/images/douong_redbull.png',
        description: 'Trái cây tươi ngon và bổ dưỡng.',
        quantity: 1, // Khởi tạo số lượng sản phẩm
      ),
    ];

    for (final product in sampleProducts) {
      await _database.productDao.insertProduct(product);
    }
  }

  Future<void> _loadProducts() async {
    try {
      final loadedProducts = await _database.productDao.getAllProducts();
      setState(() {
        products = loadedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi khi tải sản phẩm: $e')));
    }
  }

  // Hàm để thêm vào giỏ hàng
  void _addToCart(Product product) {
    setState(() {
      cartProducts.add(product);
    });
    print("Products in cart: $cartProducts");
  }

  // Hàm thêm và xóa sản phẩm khỏi danh sách yêu thích
  void _toggleFavorite(Product product) {
    setState(() {
      if (favoriteProducts.contains(product)) {
        favoriteProducts.remove(product); // Nếu sản phẩm đã có trong yêu thích, bỏ nó ra
      } else {
        favoriteProducts.add(product); // Nếu sản phẩm chưa có trong yêu thích, thêm nó vào
      }
    });
    print("Favorite products after toggle: $favoriteProducts"); // Debugging trạng thái sau khi nhấn vào trái tim
  }

  // Hàm xóa sản phẩm khỏi danh sách yêu thích
  void _removeFromFavorites(Product product) {
    setState(() {
      favoriteProducts.remove(product); // Xóa sản phẩm khỏi danh sách yêu thích
    });
    print("Favorite products after removal: $favoriteProducts"); // Debugging sau khi xóa sản phẩm
  }

  // Hàm tăng hoặc giảm số lượng sản phẩm trong giỏ hàng
  void _updateCartQuantity(Product product, int delta) {
    setState(() {
      // Tìm sản phẩm trong giỏ hàng và thay đổi số lượng
      int index = cartProducts.indexOf(product);
      if (index != -1) {
        cartProducts[index].quantity += delta;
        if (cartProducts[index].quantity < 1) {
          cartProducts[index].quantity = 1; // Đảm bảo số lượng không nhỏ hơn 1
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products
        .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Grocery App"),
        actions: [
          IconButton(
            onPressed: () async {
              print("Favorite products before navigating to FavoriteScreen: $favoriteProducts");
              final updatedFavorites = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return FavoriteScreen(
                      favoriteItems: favoriteProducts,
                      onRemoveFavorite: _removeFromFavorites,
                    );
                  },
                ),
              );
              if (updatedFavorites != null) {
                setState(() {
                  favoriteProducts = updatedFavorites;
                  print("Favorites after returning: $favoriteProducts");
                });
              }
            },
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
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
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: filteredProducts.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3.3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return ProductCart(
                          product: product,
                          onFavorite: _toggleFavorite,
                          isFavorite: favoriteProducts.contains(product),
                          onAddToCart: _addToCart,
                          onUpdateQuantity: _updateCartQuantity, // Thêm hàm cập nhật số lượng vào đây
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Giỏ hàng',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            // Chuyển đến màn hình giỏ hàng và truyền danh sách giỏ hàng
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(cartItems: cartProducts, cartProducts: [],), // Truyền giỏ hàng
              ),
            );
          }
        },
      ),
    );
  }
}
