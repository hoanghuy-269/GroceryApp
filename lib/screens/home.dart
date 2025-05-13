import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/database/app_database.dart';
import 'ProductCart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> products = [];
  String searchQuery = '';
  bool isLoading = true;
  late AppDatabase _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  // hàm init chỉ tạo một lần giống oncreate
  Future<void> _initDatabase() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    await _addSampleProducts();
    _loadProducts();
  }

  // hàm add sản phẩm
  Future<void> _addSampleProducts() async {
    final xulisanpham = await _database.productDao.getAllProducts();
    if (xulisanpham.isEmpty) {
      final sampleProducts = [
        Product(
          name: 'Bánh Oreo',
          price: 20,
          imgURL: 'assets/images/doan_banhoreo.png',
          description: 'Sữa tươi nguyên chất.',
          quantity: 100,
        ),
        Product(
          name: 'Cocacola',
          price: 10,
          imgURL: 'assets/images/doan_banhoreo.png',
          description: 'Bánh mì tươi ngon.',
          quantity: 50,
        ),
        Product(
          name: 'Red Bull',
          price: 30,
          imgURL: 'assets/images/douong_redbull.png',
          description: 'Trái cây tươi ngon và bổ dưỡng.',
          quantity: 75,
        ),
      ];

      for (final product in sampleProducts) {
        await _database.productDao.insertProduct(product);
      }
    }
  }

  // hàm load Sản phẩm
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi tải sản phẩm: $e')));
    }
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03,
        ),
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
            ),
          ],
        ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${product.price.toStringAsFixed(3)} đ',
              style: const TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      // Logic thêm vào giỏ hàng
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.shopping_cart),
                        SizedBox(width: 8),
                        Text('Thêm vào giỏ'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

