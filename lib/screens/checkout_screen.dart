import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/models/purchaseHistory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'success_screen.dart';
import 'package:grocery_app/database/database_provider.dart';

class CheckoutScreen extends StatefulWidget {
  final Product product;

  const CheckoutScreen({super.key, required this.product});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _quantity = 1;
  late AppDatabase _database;
  Product? _product;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initDatabaseAndLoadProduct();
  }

  Future<void> _initDatabaseAndLoadProduct() async {
    _database = await DatabaseProvider.database;
    await _loadProduct();
  }

  Future<void> _loadProduct() async {
    final productDao = _database.productDao;
    final productFromDB = await productDao.findProductByID(widget.product.id!);

    if (productFromDB != null) {
      setState(() {
        _product = productFromDB;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      _showDialog('Lỗi', 'Không tìm thấy sản phẩm.');
    }
  }

  Future<void> _checkout() async {
    if (_product == null) {
      _showDialog('Lỗi', 'Sản phẩm không hợp lệ.');
      return;
    }

    if (_quantity > _product!.quantity) {
      _showDialog('Hết hàng', 'Không đủ số lượng trong kho.');
      return;
    }

    final email = await SharedPreferences.getInstance();
    String? userEmail = email.getString('user_email');

    if (userEmail == null || userEmail.isEmpty) {
      _showDialog('Lỗi', 'Vui lòng đăng nhập để tiếp tục.');
      return;
    }

    // Tính tổng giá dựa trên giá đã giảm (nếu có)
    final totalPrice = _product!.discount! > 0
        ? _product!.price * (1 - _product!.discount! / 100) * _quantity
        : _product!.price * _quantity;

    final purchaseHistory = PurchaseHistory(
      email: userEmail.trim(),
      product: _product!.name,
      quantity: _quantity,
      total: totalPrice,
      date: DateTime.now().toIso8601String(),
    );

    final purchaseHistoryDao = _database.purchaseHistoryDao;
    await purchaseHistoryDao.insertHistory(purchaseHistory);

    // Cập nhật số lượng sản phẩm
    _product!.quantity -= _quantity;
    if (_product!.quantity == 0) {
      _product!.status = 'Hết hàng';
    }

    final productDao = _database.productDao;
    await productDao.updateProduct(_product!);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SuccessScreen()),
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Đang tải sản phẩm...'),
                  ],
                ),
              )
            : _product == null
                ? const Center(child: Text('Không tìm thấy sản phẩm.'))
                : ListView(
                    children: [
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 120,
                                    maxHeight: 120,
                                  ),
                                  child: Image.file(
                                    File(widget.product.imgURL),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(
                                      Icons.broken_image,
                                      size: 70,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _product!.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _product!.discount! > 0
                                          ? 'Giá: ${(_product!.price * (1 - _product!.discount! / 100)).toStringAsFixed(3)} VNĐ (Giảm ${_product!.discount}%)'
                                          : 'Giá: ${_product!.price.toStringAsFixed(3)} VNĐ',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 8,
                                      children: [
                                        const Text(
                                          'SL:',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          constraints: const BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                          onPressed: _quantity > 1
                                              ? () => setState(() => _quantity--)
                                              : null,
                                        ),
                                        Text(
                                          '$_quantity',
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          constraints: const BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                          onPressed: _quantity < _product!.quantity
                                              ? () => setState(() => _quantity++)
                                              : null,
                                        ),
                                      ],
                                    ),
                                    if (_quantity > _product!.quantity)
                                      const Text(
                                        'Số lượng vượt quá tồn kho!',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _checkout,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Thanh Toán',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}