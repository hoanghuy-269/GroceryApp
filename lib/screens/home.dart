import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/screens/cartscreen.dart'; // Import màn hình giỏ hàng
import 'package:grocery_app/screens/favourite_screen.dart';
import 'package:grocery_app/database/app_database.dart';

import 'package:grocery_app/models/ProductCart .dart'; 

import 'ProductCart.dart';


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

  // Sửa key thành int
  Map<String, dynamic> selectCategory = {"label": "Tất cả", "key": 0};

  // Sửa key thành int trong categories
  final List<Map<String, dynamic>> categories = [
    {"label": "Tất cả", "key": 0},
    {"label": "Đồ Ăn", "key": 1},
    {"label": "Nước Uống", "key": 2},
    {"label": "Mì - Cháo Ăn liền", "key": 3},
    {"label": "Gia vị", "key": 4},
    {"label": "Đồ dùng học tập", "key": 5},
    {"label": " Đồ dùng trong gia đình", "key": 6},
  ];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {

    _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    await _addSampleProducts();
    _loadProducts();

    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
       await _database.productDao.deleteAllProducts();
       await _addSampleProducts();
       await _loadProducts(); // Tải sản phẩm sau khi thêm mẫu

  }

  Future<void> _addSampleProducts() async {
    final sampleProducts = [
      Product(
        name: 'Cháo Gấu Đỏ',
        price: 15,
        imgURL: 'assets/images/chao_gaudo.png',
        description:
            'Cháo ăn liền tiện lợi, thơm ngon, thích hợp cho bữa sáng nhanh gọn.',
        quantity: 120,
        loai: 3,
      ),
      Product(
        name: 'Bánh Petit',
        price: 25,
        imgURL: 'assets/images/doan_petit.png',
        description: 'Bánh quy mềm thơm bơ, thích hợp dùng kèm trà hoặc sữa.',
        quantity: 80,
        loai: 1,
      ),
      Product(
        name: 'Gia vị kho cá',
        price: 18,
        imgURL: 'assets/images/giavi_khoca.png',
        description:
            'Gia vị đậm đà, giúp món cá kho thơm ngon, chuẩn vị truyền thống.',
        quantity: 60,
        loai: 4,
      ),
      Product(
        name: 'Bộ dụng cụ tô màu cho bé',
        price: 50,
        imgURL: 'assets/images/hoctap_emtapve.png',
        description:
            'Bộ tô màu an toàn cho trẻ em, kích thích khả năng sáng tạo.',
        quantity: 45,
        loai: 5,
      ),
      Product(
        name: 'Mì tôm Hảo Hảo',
        price: 7,
        imgURL: 'assets/images/mi_haohao.png',
        description: 'Mì ăn liền vị chua cay, ngon tuyệt cho mọi bữa ăn nhanh.',
        quantity: 200,
        loai: 3,
      ),
      Product(
        name: 'Bột Giặt Omo',
        price: 45,
        imgURL: 'assets/images/trongnha_omo.png',
        description: 'Bột giặt sạch vượt trội, đánh bay mọi vết bẩn cứng đầu.',
        quantity: 90,
        loai: 6,
      ),
      Product(
        name: 'Bánh Oreo',
        price: 22,
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

        description: 'Bánh quy nhân kem sữa, giòn tan, ngọt ngào.',
        quantity: 110,
        loai: 1,
      ),
      Product(
        name: 'CoCaCoLa',
        price: 8,
        imgURL: 'assets/images/douong_cocacola.png',
        description:
            ' Nước giải khát mát lạnh, sảng khoái tức thì, thích hợp cho mọi độ tuổi.',
        quantity: 150,
        loai: 2,
      ),
      Product(
        name: 'Gia Vị Bột Chiên',
        price: 20,
        imgURL: 'assets/images/giavi_botchien.png',
        description:
            'Gia vị pha sẵn giúp món bột chiên thêm hấp dẫn và đậm đà.',
        quantity: 65,
        loai: 3,
      ),
      Product(
        name: 'hộp bút mực',
        price: 35,
        imgURL: 'assets/images/hoctap_but.png',
        description: 'Bộ bút mực tiện dụng cho học sinh và sinh viên.',
        quantity: 100,
        loai: 5,
      ),
      Product(
        name: 'Mì tôm Ba Miền',
        price: 8,
        imgURL: 'assets/images/mi_3mien.png',
        description:
            'Mì ăn liền với hương vị độc đáo từ 3 miền Bắc - Trung - Nam.',
        quantity: 150,
        loai: 3,

      ),
      Product(
        name: 'Red Bull ',
        price: 8,
        imgURL: 'assets/images/douong_redbull.png',

        description: 'Trái cây tươi ngon và bổ dưỡng.',
        quantity: 1, // Khởi tạo số lượng sản phẩm

        description:
            'Hương vị đậm đà, bổ sung năng lượng và giúp bạn luôn tỉnh táo suốt ngày dài.',
        quantity: 150,
        loai: 2,
      ),
      Product(
        name: 'Bộ chén sứ trắng',
        price: 60,
        imgURL: 'assets/images/trongnha_bochen.png',
        description:
            'Bộ chén cao cấp, thiết kế tinh tế, phù hợp mọi không gian bếp.',
        quantity: 40,
        loai: 6,

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

    setState(() {
      isLoading = true;
    });

    List<Product> loadedProducts = [];
    final categoryKey = selectCategory["key"] as int; // Ép kiểu thành int

    if (categoryKey == 0) {
      loadedProducts = await _database.productDao.getAllProducts();
    } else {
      loadedProducts = await _database.productDao.getProductByCategory(
        categoryKey,
      ); // Sửa tên hàm

    }

    setState(() {
      products = loadedProducts;
      isLoading = false;
    });
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    categories.map((category) {
                      return _buildCategoryButton(
                        category,
                        category['key'] == selectCategory['key'],
                      );
                    }).toList(),
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

              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: filteredProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3 / 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ProductCart(product: product);
                        },

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

    );
  }

  Widget _buildCategoryButton(Map<String, dynamic> category, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Colors.green[400] : Colors.grey[200],
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onPressed: () {
          setState(() {
            selectCategory = category;
          });
          _loadProducts();
        },
        child: Text(category['label']!),
      ),
    );
  }
}

class ProductCart extends StatefulWidget {
  final Product product;

  const ProductCart({super.key, required this.product});

  @override
  State<ProductCart> createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Stack để chồng hình và icon
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child:
                    product.imgURL.startsWith('assets/')
                        ? Image.asset(
                          product.imgURL,
                          fit: BoxFit.cover,
                          height: 100,
                          width: double.infinity,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 50),
                        )
                        : Image.network(
                          product.imgURL,
                          fit: BoxFit.cover,
                          height: 100,
                          width: double.infinity,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 50),
                        ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: InkWell(
                  onTap: toggleFavorite,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ],

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

