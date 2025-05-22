import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/screens/cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> allProducts = [];

  List<Product> cartItems = [];
  void _addToCart(Product product) {
    setState(() {
      // Tìm trong giỏ hàng theo id
      final index = cartItems.indexWhere((item) => item.id == product.id);

      if (index != -1) {
        final updated = cartItems[index].copyWith(
          quantity: cartItems[index].quantity + 1,
        );
        cartItems[index] = updated;
        debugPrint('[UPDATE] Đã tăng số lượng: ${updated.toString()}');
      } else {
        final newProduct = product.copyWith(quantity: 1);
        cartItems.add(newProduct);
        debugPrint('[ADD NEW] Đã thêm mới: ${newProduct.toString()}');
      }

      _debugCartContents(); // In danh sách giỏ hàng sau khi cập nhật
    });
  }

  void _debugCartContents() {
    debugPrint('=== DANH SÁCH GIỎ HÀNG HIỆN TẠI ===');
    for (var item in cartItems) {
      debugPrint('${item.toString()}');
    }
    debugPrint('===================================');
  }

  void _goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CartScreen(cartItems: [])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách sản phẩm'),
        actions: [
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: _goToCart),
        ],
      ),
      body: ListView.builder(
        itemCount: allProducts.length,
        itemBuilder: (context, index) {
          final product = allProducts[index];
          return ListTile(
            leading: Image.asset(product.imgURL, width: 50),
            title: Text(product.name),
            subtitle: Text('${product.price} đ'),
            trailing: ElevatedButton(
              onPressed: () => _addToCart(product),
              child: Text('Thêm'),
            ),
          );
        },
      ),
    );
  }
}
