import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';

class CartScreen extends StatefulWidget {
  final List<Product> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Product> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.cartItems); // Tạo bản sao có thể sửa đổi
  }

  void _incrementQuantity(int index) {
    setState(() {
      final item = _cartItems[index];
      _cartItems[index] = item.copyWith(quantity: item.quantity + 1);
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      final item = _cartItems[index];
      if (item.quantity > 1) {
        _cartItems[index] = item.copyWith(quantity: item.quantity - 1);
      } else {
        _cartItems.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double deliveryFee = 25.0;
    double discount = 0.0;

    double subTotal = _cartItems.fold(
      0.0,
      (total, item) => total + (item.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ Hàng')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _cartItems.isEmpty
                ? Expanded(
                  child: Center(
                    child: Text(
                      'Giỏ hàng trống',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                )
                : Expanded(
                  child: ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              _buildProductImage(item.imgURL),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
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
            _buildPriceRow('Delivery Fee:', deliveryFee),
            const Divider(),
            _buildPriceRow(
              'Total Cost:',
              subTotal + deliveryFee - discount,
              isTotal: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _cartItems.isEmpty
                      ? null
                      : () {
                        // TODO: Xử lý thanh toán
                      },
              child: const Text('Proceed to Checkout'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
    if (file.existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          file,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 80),
        ),
      );
    } else {
      // fallback: nếu file không tồn tại, thử dùng assets
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imgURL,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 80),
        ),
      );
    }
  }
}
