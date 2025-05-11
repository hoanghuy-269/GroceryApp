import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/database/database_helper.dart';
import 'package:grocery_app/screens/product_detal_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> products = [];
  String searchQuery = '';
  bool isLoading = true;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  // initState giống oncreate : chỉ được gọi một lần trong vòng đời
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Tải sản phẩm từ cơ sở dữ liệu
  Future<void> _loadProducts() async {
    try {
      final loadedProducts = await _dbHelper.getProducts();
      setState(() {
        products = loadedProducts;
        isLoading = false;
      });
      // In dữ liệu ra console để kiểm tra
      print('\nDanh sách sản phẩm từ cơ sở dữ liệu:');
      if (loadedProducts.isEmpty) {
        print('Không có sản phẩm nào trong cơ sở dữ liệu');
      } else {
        for (var product in loadedProducts) {
          print(
            'Tên: ${product.name}, Giá: ${product.price} VND, Số lượng: ${product.quantity}, Mô tả: ${product.description}, Hình ảnh: ${product.imgURL}',
          );
        }
      }
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
    // tìm kiếm sản phẩm 
    final filteredProducts =
        products
            .where(
              (p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Groceryapp"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: ' Tìm kiếm sản phẩm ...',
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
                            childAspectRatio: 2 / 3.3,
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
    );
  }
}

class ProductCart extends StatelessWidget {
  final Product product;
  const ProductCart({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
            child:
                product.imgURL.startsWith('assets/')
                    ? Image.asset(
                      product.imgURL,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 50),
                    )
                    : Image.network(
                      product.imgURL,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 50),
                    ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${product.price.toStringAsFixed(3)} đ',
              style: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: 
                const [
                    Icon(Icons.shopping_cart),
                    SizedBox(width: 8),
                   Text('Thêm vào giỏ'),
                  ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
