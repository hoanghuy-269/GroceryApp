import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart'; // Import mô hình sản phẩm
import 'package:grocery_app/screens/favourite_screen.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/screens/product_detail_screen.dart';

class Home extends StatefulWidget {
  final Function(Product) onAddToCart; // Hàm thêm vào giỏ hàng

  const Home({super.key, required this.onAddToCart}); // Nhận hàm từ MyBottom

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> products = []; // Danh sách sản phẩm
  List<Product> favoriteProducts = []; // Danh sách yêu thích
  String searchQuery = ''; // Tìm kiếm sản phẩm
  bool isLoading = true; // Trạng thái loading
  late AppDatabase _database; // Cơ sở dữ liệu

  Map<String, dynamic> selectCategory = {
    "label": "Tất cả",
    "key": 0,
  }; // Danh mục sản phẩm đã chọn

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

  // Khởi tạo cơ sở dữ liệu và tải sản phẩm
  Future<void> _initDatabase() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    await _database.productDao.deleteAllProducts();
    await _addSampleProducts(); // Thêm sản phẩm mẫu
   //  await _loadProducts(); // Tải danh sách sản phẩm
  }
  

  // Thêm sản phẩm mẫu vào cơ sở dữ liệu
  Future<void> _addSampleProducts() async {
    final sampleProducts = [
      Product( 
        id: 1,
        name: 'Bánh Petit',
        price: 25,
        imgURL: 'assets/images/doan_petit.png',
        description: 'Bánh quy mềm thơm bơ, thích hợp dùng kèm trà hoặc sữa.',
        quantity: 80,
        loai: 1,
        status: "Còn hàng",
        lastUpdated: DateTime(1)
      ),
      Product(
        id: 2,
        
        name: 'Gia vị kho cá',
        price: 18,
        imgURL: 'assets/images/giavi_khoca.png',
        description:
            'Gia vị đậm đà, giúp món cá kho thơm ngon, chuẩn vị truyền thống.',
        quantity: 60,
        loai: 4,
        status: "Còn hàng",
         lastUpdated: DateTime(1)

      ),
    ];
    for (final product in sampleProducts) {
      await _database.productDao.insertProduct(
        product,
      ); // Thêm từng sản phẩm vào cơ sở dữ liệu
    }
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

  // Hàm thêm sản phẩm vào giỏ hàng
  void _addToCart(Product product) {
    setState(() {
      widget.onAddToCart(product); // Gọi hàm từ widget cha (MyBottom)
    });

    // Hiển thị thông báo sản phẩm đã được thêm vào giỏ hàng
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} đã được thêm vào giỏ hàng')),
    );
  }

  // Hàm thêm hoặc xóa sản phẩm khỏi danh sách yêu thích
  void _toggleFavorite(Product product) {
    setState(() {
      if (favoriteProducts.contains(product)) {
        favoriteProducts.remove(
          product,
        ); // Nếu đã yêu thích, xóa khỏi danh sách yêu thích
      } else {
        favoriteProducts.add(
          product,
        ); // Nếu chưa yêu thích, thêm vào danh sách yêu thích
      }
    });
  }

  // Hàm xử lý thay đổi khi người dùng tìm kiếm sản phẩm
  @override
  Widget build(BuildContext context) {
    final filteredProducts =
        products
            .where(
              (p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()),
            ) // Lọc sản phẩm theo tên
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
          horizontal:
              MediaQuery.of(context).size.width *
              0.03, // Căn lề theo chiều ngang
        ),
        child: Column(
          children: [
            // Widget tìm kiếm sản phẩm
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
                  searchQuery = value; // Cập nhật tìm kiếm khi người dùng nhập
                });
              },
            ),
            // Widget danh mục sản phẩm
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    categories.map((category) {
                      return _buildCategoryButton(
                        category,
                        category['key'] ==
                            selectCategory['key'], // Kiểm tra xem danh mục có được chọn không
                      );
                    }).toList(),
              ),
            ),
            // Danh sách sản phẩm
            Expanded(
              child:
                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator(),
                      ) // Hiển thị khi đang tải dữ liệu
                      : GridView.builder(
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
                            onFavorite: _toggleFavorite, // Truyền hàm yêu thích
                            isFavorite: favoriteProducts.contains(product),
                            onAddToCart:
                                _addToCart, // Truyền hàm thêm vào giỏ hàng
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget xây dựng nút chọn danh mục
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
            selectCategory = category; // Cập nhật danh mục được chọn
          });
          _loadProducts(); // Tải lại sản phẩm khi danh mục thay đổi
        },
        child: Text(category['label']),
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
                  child: Image.asset(
                    product.imgURL,
                    fit: BoxFit.cover,
                    height: 100,
                    width: double.infinity,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${product.price.toStringAsFixed(3)} VND'),
          ),
          ElevatedButton(
            onPressed: () => onAddToCart(product), // Gọi hàm _addToCart
            child: const Text('Thêm vào giỏ hàng'),
          ),
        ],
      ),
    );
  }
}
