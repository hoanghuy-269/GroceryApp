import 'package:flutter/material.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/models/purchaseHistory.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({Key? key}) : super(key: key);

  @override
  _PurchaseHistoryPageState createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  List<PurchaseHistory> _purchases = [];
  bool _isLoading = false;
  String? _errorMessage;
  AppDatabase? _database;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _initDatabaseAndLoadData();
  }

  Future<void> _initDatabaseAndLoadData() async {
    try {
      // Khởi tạo database
      _database =
          await $FloorAppDatabase.databaseBuilder('app_database.db').build();

      // Lấy email đã lưu
      final prefs = await SharedPreferences.getInstance();
      String? savedEmail = prefs.getString('user_email');

      if (savedEmail == null || savedEmail.isEmpty) {
        setState(() {
          _errorMessage = 'Không tìm thấy email người dùng đã đăng nhập.';
        });
        return;
      }

      setState(() {
        _userEmail = savedEmail;
        _isLoading = true;
        _errorMessage = null;
      });

      // Lấy dữ liệu lịch sử mua hàng
      final dao = _database!.purchaseHistoryDao;
      final purchases = await dao.getHistoryByEmail(savedEmail.trim());

      setState(() {
        _purchases = purchases;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi khởi tạo hoặc lấy dữ liệu: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch Sử Mua Hàng')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_userEmail != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Email: $_userEmail',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red))
            else if (_purchases.isEmpty)
              const Text('Không tìm thấy lịch sử mua hàng.')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _purchases.length,
                  itemBuilder: (context, index) {
                    final purchase = _purchases[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text('Sản phẩm: ${purchase.product}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Số lượng: ${purchase.quantity}'),
                            Text(
                              'Tổng tiền: ${purchase.total.toStringAsFixed(2)} VNĐ',
                            ),
                            Text('Ngày: ${purchase.date}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _database?.close();
    super.dispose();
  }
}
