import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';

class InvoiceScreen extends StatelessWidget {
  final List<Product> products;

  const InvoiceScreen({super.key, required this.products});

  double get totalAmount =>
      products.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hóa Đơn Thanh Toán')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: products.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = products[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('Số lượng: ${item.quantity}'),
                    trailing: Text(
                      '${(item.price * item.quantity).toStringAsFixed(3)} đ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            const Divider(thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng cộng:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${totalAmount.toStringAsFixed(3)} đ',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
