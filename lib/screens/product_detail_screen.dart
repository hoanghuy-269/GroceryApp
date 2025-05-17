import 'dart:io'; // Thêm import
import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/screens/checkout_screen.dart';
import 'package:grocery_app/database/app_database.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late AppDatabase _database;
  Product? _product;

  @override
  void initState() {
    super.initState();
    _loadProductFromDB();
  }

  Future<void> _loadProductFromDB() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    final productFromDB = await _database.productDao.findProductByID(
      widget.product.id!,
    );

    if (productFromDB != null) {
      setState(() {
        _product = productFromDB;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_product == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(_product!.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child:
                  _product!.imgURL.isNotEmpty
                      ? Image.file(
                        File(_product!.imgURL),
                        fit: BoxFit.fill,
                        height: 200,
                        width: double.infinity,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 50),
                      )
                      : const Icon(Icons.image_not_supported, size: 50),
            ),
            const SizedBox(height: 16),
            Text(
              _product!.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${_product!.price.toStringAsFixed(3)} VNĐ',
              style: const TextStyle(fontSize: 20, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            const Text(
              "Mô tả:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(_product!.description),
            const SizedBox(height: 16),
            Text(
              _product!.quantity == 0
                  ? "Tình trạng: Hết hàng"
                  : "Tồn kho: ${_product!.quantity}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _product!.quantity == 0 ? Colors.red : Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            if (_product!.quantity > 0)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                CheckoutScreen(product: widget.product),
                      ),
                    );
                    _loadProductFromDB(); // Cập nhật sau khi quay lại
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text("Mua ngay"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
