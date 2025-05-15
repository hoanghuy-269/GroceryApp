import 'package:flutter/material.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/models/PurchaseHistory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'success_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _khoiTaoCSDL();
  }

  Future<void> _khoiTaoCSDL() async {
    _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    await _loadProduct();
  }

  Future<void> _loadProduct() async {
    final productDao = _database.productDao;
    final productFromDB = await productDao.findProductByID(widget.product.id);
    if (productFromDB != null) {
      setState(() {
        _product = productFromDB;
      });
    } else {
      _showDialog('Lỗi', 'Không tìm thấy sản phẩm.');
    }
  }

  Future<void> _checkout() async {
    if (_product == null) {
      _showDialog('Lỗi', 'Sản phẩm không hợp lệ.');
      return;
    }

    if (_product!.quantity < _quantity) {
      _showDialog('Hết hàng', 'Không đủ số lượng trong kho.');
      return;
    }

    // Lấy email từ SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('user_email');

    if (userEmail == null || userEmail.isEmpty) {
      _showDialog('Lỗi', 'Vui lòng đăng nhập để tiếp tục.');
      return;
    }

    // Tính tổng tiền
    final totalPrice = _product!.price * _quantity;

    // Tạo bản ghi lịch sử mua hàng
    final purchaseHistory = PurchaseHistory(
      email: userEmail.trim(),
      product: _product!.name,
      quantity: _quantity,
      total: totalPrice,
      date: DateTime.now().toIso8601String(),
    );

    // Lưu lịch sử mua hàng
    final purchaseHistoryDao = _database.purchaseHistoryDao;
    await purchaseHistoryDao.insertHistory(purchaseHistory);

    // Cập nhật số lượng sản phẩm
    _product!.quantity -= _quantity;
    final productDao = _database.productDao;
    if (_product!.quantity == 0) {
      _product!.status = 'Hết hàng';
    }
    await productDao.updateProduct(_product!);

    // Điều hướng đến SuccessScreen
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
        child: _product == null
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
            : ListView(
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              widget.product.imgURL,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 80),
                            ),
                          ),
                          const SizedBox(width: 16),
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
                                  'Giá: ${_product!.price.toStringAsFixed(3)} VNĐ',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text(
                                      'Số lượng:',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        if (_quantity > 1) {
                                          setState(() => _quantity--);
                                        }
                                      },
                                    ),
                                    Text(
                                      '$_quantity',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() => _quantity++);
                                      },
                                    ),
                                  ],
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