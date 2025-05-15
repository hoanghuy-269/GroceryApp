import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart'; // Import mô hình sản phẩm
import 'package:grocery_app/screens/favourite_screen.dart';
import 'package:grocery_app/database/app_database.dart';
<<<<<<< HEAD
import 'package:grocery_app/screens/product_detail_screen.dart';
=======
import 'package:grocery_app/screens/cartscreen.dart';
import 'package:grocery_app/screens/favourite_screen.dart';
>>>>>>> d553437e755341a3d8eb5a5d070af5ba0bfa27e4

class Home extends StatefulWidget {
  final Function(Product) onAddToCart; // Hàm thêm vào giỏ hàng

  const Home({super.key, required this.onAddToCart}); // Nhận hàm từ MyBottom

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
<<<<<<< HEAD
  List<Product> products = []; // Danh sách sản phẩm
  List<Product> favoriteProducts = []; // Danh sách yêu thích
  String searchQuery = ''; // Tìm kiếm sản phẩm
  bool isLoading = true; // Trạng thái loading
  late AppDatabase _database; // Cơ sở dữ liệu
=======
  List<Product> products = [];
  List<Product> favoriteProducts = [];
  List<Product> cartProducts = []; // Danh sách sản phẩm trong giỏ hàng
  String searchQuery = '';
  bool isLoading = true;
  late AppDatabase _database;
>>>>>>> d553437e755341a3d8eb5a5d070af5ba0bfa27e4

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
<<<<<<< HEAD
   // await _database.productDao.deleteAllProducts();
   // await _addSampleProducts(); // Thêm sản phẩm mẫu
     await _loadProducts(); // Tải danh sách sản phẩm
=======
    await _database.productDao.deleteAllProducts(); // Xóa dữ liệu cũ
    await _addSampleProducts();
    // await _loadProducts();
>>>>>>> d553437e755341a3d8eb5a5d070af5ba0bfa27e4
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
      ),
      Product(
        id: 3,
        name: 'Bộ dụng cụ tô màu cho bé',
        price: 50,
        imgURL: 'assets/images/hoctap_emtapve.png',
        description:
            'Bộ tô màu an toàn cho trẻ em, kích thích khả năng sáng tạo.',
        quantity: 45,
        loai: 5,
        status: "Còn hàng",
      ),
      Product(
        id: 4,
        name: 'Mì tôm Hảo Hảo',
        price: 7,
        imgURL: 'assets/images/mi_haohao.png',
        description: 'Mì ăn liền vị chua cay, ngon tuyệt cho mọi bữa ăn nhanh.',
        quantity: 200,
        loai: 3,
        status: "Còn hàng",
      ),
      Product(
        id: 5,
        name: 'Bột Giặt Omo',
        price: 45,
        imgURL: 'assets/images/trongnha_omo.png',
        description: 'Bột giặt sạch vượt trội, đánh bay mọi vết bẩn cứng đầu.',
        quantity: 90,
        loai: 6,
        status: "Còn hàng",
      ),
      Product(
        id: 6,
        name: 'Bánh Oreo',
        price: 22,
        imgURL: 'assets/images/doan_banhoreo.png',
        description: 'Bánh quy nhân kem sữa, giòn tan, ngọt ngào.',
        quantity: 110,
        loai: 1,
        status: "Còn hàng",
      ),
      Product(
<<<<<<< HEAD
        id: 7,
=======
>>>>>>> d553437e755341a3d8eb5a5d070af5ba0bfa27e4
        name: 'CocaCola',
        price: 8,
        imgURL: 'assets/images/douong_cocacola.png',
        description:
            'Nước giải khát mát lạnh, sảng khoái tức thì, thích hợp cho mọi độ tuổi.',
        quantity: 150,
        loai: 2,
        status: "Còn hàng",
      ),
      Product(
        id: 8,
        name: 'Gia Vị Bột Chiên',
        price: 20,
        imgURL: 'assets/images/giavi_botchien.png',
        description:
            'Gia vị pha sẵn giúp món bột chiên thêm hấp dẫn và đậm đà.',
        quantity: 65,
        loai: 3,
        status: "Còn hàng",
      ),
      Product(
<<<<<<< HEAD
        id: 9,
=======
>>>>>>> d553437e755341a3d8eb5a5d070af5ba0bfa27e4
        name: 'Hộp bút mực',
        price: 35,
        imgURL: 'assets/images/hoctap_but.png',
        description: 'Bộ bút mực tiện dụng cho học sinh và sinh viên.',
        quantity: 100,
        loai: 5,
        status: "Còn hàng",
      ),
      Product(
        id: 10,
        name: 'Mì tôm Ba Miền',
        price: 8,
        imgURL: 'assets/images/mi_3mien.png',
        description:
            'Mì ăn liền với hương vị độc đáo từ 3 miền Bắc - Trung - Nam.',
        quantity: 150,
        loai: 3,
        status: "Còn hàng",
      ),
      Product(
<<<<<<< HEAD
        id: 11,
=======
>>>>>>> d553437e755341a3d8eb5a5d070af5ba0bfa27e4
        name: 'Red Bull',
        price: 8,
        imgURL: 'assets/images/douong_redbull.png',
        description:
            'Hương vị đậm đà, bổ sung năng lượng và giúp bạn luôn tỉnh táo suốt ngày dài.',
        quantity: 150,
        loai: 2,
        status: "Còn hàng",
      ),
      Product(
        id: 12,
        name: 'Bộ chén sứ trắng',
        price: 60,
        imgURL: 'assets/images/trongnha_bochen.png',
        description:
            'Bộ chén cao cấp, thiết kế tinh tế, phù hợp mọi không gian bếp.',
        quantity: 40,
        loai: 6,
        status: "Còn hàng",
      ),
      // Thêm các sản phẩm mẫu khác nếu cần
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

<<<<<<< HEAD
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
=======
  // Hàm thêm vào giỏ hàng
  void _addToCart(Product product) {
    setState(() {
      cartProducts.add(product);
    });
  }

  // Hàm thêm/xóa sản phẩm khỏi danh sách yêu thích
  void _toggleFavorite(Product product) {
    setState(() {
      if (favoriteProducts.contains(product)) {
        favoriteProducts.remove(product);
      } else {
        favoriteProducts.add(product);
      }
    });
  }

  // Hàm xóa sản phẩm khỏi danh sách yêu thích
  void _removeFromFavorites(Product product) {
    setState(() {
      favoriteProducts.remove(product);
>>>>>>> d553437e755341a3d8eb5a5d070af5ba0bfa27e4
    });
  }

  // Hàm xử lý thay đổi khi người dùng tìm kiếm sản phẩm
  @override
  Widget build(BuildContext context) {
    // Lọc sản phẩm dựa trên từ khóa tìm kiếm
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
<<<<<<< HEAD
                  builder: (context) {
                    return FavoriteScreen(
                      favoriteItems: favoriteProducts,
                      onRemoveFavorite: _toggleFavorite,
                    );
                  },
                ),
              );

=======
                  builder:
                      (context) => FavoriteScreen(
                        // favoriteItems: favoriteProducts,
                        // onRemoveFavorite: _removeFromFavorites,
                      ),
                ),
              );
>>>>>>> d553437e755341a3d8eb5a5d070af5ba0bfa27e4
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
<<<<<<< HEAD
            // Widget tìm kiếm sản phẩm
            TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm ...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
=======
            // Ô tìm kiếm
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sản phẩm...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
>>>>>>> d553437e755341a3d8eb5a5d070af5ba0bfa27e4
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Cập nhật tìm kiếm khi người dùng nhập
                });
              },
            ),
<<<<<<< HEAD
            // Widget danh mục sản phẩm
=======
            // Danh sách danh mục
>>>>>>> d553437e755341a3d8eb5a5d070af5ba0bfa27e4
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    categories.map((category) {
<<<<<<< HEAD
                      return _buildCategoryButton(
                        category,
                        category['key'] ==
                            selectCategory['key'], // Kiểm tra xem danh mục có được chọn không
=======
                      final isSelected =
                          category['key'] == selectCategory['key'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                          ),
                          onPressed: () {
                            setState(() {
                              selectCategory = category;
                            });
                            _loadProducts();
                          },
                          child: Text(category['label']),
                        ),
>>>>>>> d553437e755341a3d8eb5a5d070af5ba0bfa27e4
                      );
                    }).toList(),
              ),
            ),
<<<<<<< HEAD
            // Danh sách sản phẩm
            Expanded(
              child:
                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator(),
                      ) // Hiển thị khi đang tải dữ liệu
=======
            // Lưới sản phẩm
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredProducts.isEmpty
                      ? const Center(child: Text('Không tìm thấy sản phẩm'))
>>>>>>> d553437e755341a3d8eb5a5d070af5ba0bfa27e4
                      : GridView.builder(
                        padding: const EdgeInsets.all(8.0),
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
<<<<<<< HEAD
                          return ProductCard(
                            product: product,
                            onFavorite: _toggleFavorite, // Truyền hàm yêu thích
                            isFavorite: favoriteProducts.contains(product),
                            onAddToCart:
                                _addToCart, // Truyền hàm thêm vào giỏ hàng
=======
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Hình ảnh sản phẩm
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      child: Image.asset(
                                        product.imgURL,
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.broken_image,
                                                  size: 50,
                                                ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: IconButton(
                                        onPressed:
                                            () => _toggleFavorite(product),
                                        icon: Icon(
                                          favoriteProducts.contains(product)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color:
                                              favoriteProducts.contains(product)
                                                  ? Colors.red
                                                  : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Thông tin sản phẩm
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    '${product.price} VNĐ',
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                ),
                                // Nút thêm vào giỏ hàng
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () => _addToCart(product),
                                      icon: const Icon(Icons.add_shopping_cart),
                                    ),
                                  ],
                                ),
                              ],
                            ),
>>>>>>> d553437e755341a3d8eb5a5d070af5ba0bfa27e4
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD

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
=======
}
>>>>>>> d553437e755341a3d8eb5a5d070af5ba0bfa27e4
