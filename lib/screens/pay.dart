import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';
import 'InvoiceScreen.dart'; // Đảm bảo đường dẫn đúng với file invoice.dart của bạn

class PayScreen extends StatelessWidget {
  final double totalAmount;
  final List<Product> products;

  const PayScreen({
    super.key,
    required this.totalAmount,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh Toán')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Tổng số tiền cần thanh toán:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              '${totalAmount.toStringAsFixed(3)} đ',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvoiceScreen(products: products),
                  ),
                );
              },
              child: const Text('Thanh Toán Ngay'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
