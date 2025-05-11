import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple, // Thêm màu cho app bar
      ),
      body: SingleChildScrollView( // Để cuộn được khi nội dung dài
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _checkoutRow('Delivery', 'Select Method'),
                _checkoutRow('Payment', '', icon: Icons.payment),
                _checkoutRow('Promo Code', 'Pick Discount'),
                _checkoutRow('Total Cost', '\$13.97', isBold: true),
                const SizedBox(height: 10),
                const Text.rich(
                  TextSpan(
                    text: 'By placing an order you agree to our ',
                    children: [
                      TextSpan(
                        text: 'Terms ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: 'and '),
                      TextSpan(
                        text: 'Conditions',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      // Thực hiện xử lý khi nhấn
                    },
                    child: const Text(
                      'Place Order',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _checkoutRow(String title, String subtitle,
      {bool isBold = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(icon, size: 18),
            ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
