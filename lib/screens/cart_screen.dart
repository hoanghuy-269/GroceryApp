import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/database/database_provider.dart';
import 'package:grocery_app/models/cart.dart';
import 'package:grocery_app/screens/pay.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> _cartItems;
  late AppDatabase _database;

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.cartItems);
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await DatabaseProvider.database;
  }

  void _incrementQuantity(int index) async {
    setState(() {
      final item = _cartItems[index];
      _cartItems[index] = CartItem(
        id: item.id,
        productId: item.productId,
        productName: item.productName,
        price: item.price,
        imgURL: item.imgURL,
        quantity: item.quantity + 1,
        discount: item.discount,
      );
    });

    // Cập nhật trong cơ sở dữ liệu
    try {
      await _database.cartItemDao.updateCartItem(_cartItems[index]);
      print(
        'Cập nhật số lượng CartItem: ${_cartItems[index].productName}, Số lượng: ${_cartItems[index].quantity}',
      );
    } catch (e) {
      print('Lỗi khi cập nhật CartItem: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi cập nhật giỏ hàng: $e')));
    }
  }

  void _decrementQuantity(int index) async {
    final item = _cartItems[index];
    if (item.quantity > 1) {
      setState(() {
        _cartItems[index] = CartItem(
          id: item.id,
          productId: item.productId,
          productName: item.productName,
          price: item.price,
          imgURL: item.imgURL,
          quantity: item.quantity - 1,
          discount: item.discount,
        );
      });

      // Cập nhật trong cơ sở dữ liệu
      try {
        await _database.cartItemDao.updateCartItem(_cartItems[index]);
        print(
          'Cập nhật số lượng CartItem: ${_cartItems[index].productName}, Số lượng: ${_cartItems[index].quantity}',
        );
      } catch (e) {
        print('Lỗi khi cập nhật CartItem: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi cập nhật giỏ hàng: $e')),
        );
      }
    } else {
      setState(() {
        _cartItems.removeAt(index);
      });

      // Xóa khỏi cơ sở dữ liệu
      try {
        await _database.cartItemDao.deleteCartItem(item);
        print('Xóa CartItem: ${item.productName}');
      } catch (e) {
        print('Lỗi khi xóa CartItem: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xóa sản phẩm khỏi giỏ hàng: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const discount = 0.0;

    final subTotal = _cartItems.fold(
      0.0,
      (total, item) => total + item.price * item.quantity,
    );

    final totalCost = subTotal - discount;

    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ Hàng')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _cartItems.isEmpty
                ? Expanded(
                  child: Center(
                    child: Text(
                      'Giỏ hàng trống',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ),
                )
                : Expanded(
                  child: ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              _buildProductImage(item.imgURL),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Price: ${item.price.toStringAsFixed(3)} đ',
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () => _decrementQuantity(index),
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () => _incrementQuantity(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            const Divider(),
            _buildPriceRow('Sub-Total:', subTotal),
            const Divider(),
            _buildPriceRow('Total Cost:', totalCost, isTotal: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _cartItems.isEmpty
                      ? null
                      : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => PayScreen(
                                  totalAmount: totalCost,
                                  products: _cartItems,
                                ),
                          ),
                        );
                      },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Proceed to Checkout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${amount.toStringAsFixed(3)} đ',
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String imgURL) {
    final file = File(imgURL);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child:
          file.existsSync()
              ? Image.file(
                file,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => const Icon(Icons.broken_image, size: 80),
              )
              : const Icon(Icons.broken_image, size: 80),
    );
  }
}
