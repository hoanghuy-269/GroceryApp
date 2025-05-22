import 'package:flutter/material.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/models/notification.dart';
import 'package:grocery_app/models/product.dart';
import 'package:intl/intl.dart';
import 'package:grocery_app/database/database_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late AppDatabase _database;
  List<Notifications> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await DatabaseProvider.database;

    // Xóa các thông báo cũ trước khi tạo mới
    await _database.notificationDao.deleteAllNotifications();

    // Tạo mới thông báo nếu sản phẩm hiện tại < 5
    final lowStockProducts = await _database.productDao.getProductsWithLowStock(
      5,
    );
    for (var product in lowStockProducts) {
      await _database.notificationDao.insertNotification(
        Notifications(
          id: DateTime.now().millisecondsSinceEpoch,
          title: 'Sản phẩm sắp hết',
          message: '${product.name} chỉ còn ${product.quantity} sản phẩm',
          timestamp: DateTime.now().toIso8601String(),
        ),
      );
    }

    // Tải tất cả thông báo để hiển thị
    final loadedNotifications =
        await _database.notificationDao.getAllNotifications();
    setState(() {
      notifications = loadedNotifications;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : notifications.isEmpty
              ? const Center(child: Text('Không có thông báo nào.'))
              : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(notification.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification.message),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat(
                              'HH:mm, dd/MM/yyyy',
                            ).format(DateTime.parse(notification.timestamp)),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
