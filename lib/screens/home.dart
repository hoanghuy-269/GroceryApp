import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Product> products = [
    Product(
      name: " San pham 1 ",
      imgURL: 'assets/images/oreo.png',
      price: 20,
      quantity: 1,
      description: " bánh ",
    ),
    Product(
      name: " San pham 2 ",
      imgURL: 'assets/images/oreo.png',
      price: 20.000,
      quantity: 1,
      description: " bánh ",
    ),
  ];

  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    final filteredProducts = products
    .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
    .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(" Groceryapp"),
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
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3.3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index)  {
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
  const ProductCart ({super.key , required this.product});
  
  @override
  Widget build(BuildContext context) {
       return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(product.imgURL, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('${product.price.toStringAsFixed(3)} đ'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('Số lượng: ${product.quantity}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Xử lý thêm vào giỏ hàng
              },
              child: const Text('Thêm vào giỏ'),
            ),
          ),
        ],
      ),
    
    );

  }
}
