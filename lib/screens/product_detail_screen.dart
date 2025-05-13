import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child:  Image.asset(
                    widget.product.imgURL,
                    fit: BoxFit.fill,
                    height: 200,
                    width: double.infinity,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50),
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.product.price.toStringAsFixed(3)} VNĐ',
              style: const TextStyle(fontSize: 20, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            const Text(
              "Mô tả:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(widget.product.description),
            const SizedBox(height: 16),
            Text("Tồn Kho: ${widget.product.quantity}"),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đã thêm vào giỏ hàng!")),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text("Thêm vào giỏ hàng"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
