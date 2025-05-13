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
