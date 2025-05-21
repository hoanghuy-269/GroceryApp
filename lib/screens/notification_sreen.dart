import 'package:flutter/material.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/models/notification.dart';
import 'package:intl/intl.dart';

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
    _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    // Xóa thông báo hết hạn
    await _database.notificationDao.deleteExpiredNotifications(
      DateTime.now().toIso8601String(),
    );

    // Thêm thông báo giảm giá mẫu nếu database rỗng
    final existingNotifications =
        await _database.notificationDao.getAllNotifications();
    if (existingNotifications.isEmpty) {
      await _database.notificationDao.insertNotification(
        Notifications(
          title: 'Khuyến mãi mới',
          message: 'Giảm 20% cho tất cả mì ăn liền từ 17/05 đến 20/05/2025!',
          timestamp: DateTime.now().toIso8601String(),
          type: 'promotion',
          discount: 20.0,
          endDate: DateTime(2025, 5, 18, 20, 10, 59).toIso8601String(),
          key: 3,
          id: 1,
        ),
      );
      // await _database.notificationDao.insertNotification(
      //   Notifications(
      //     title: 'Khuyến mãi mới',
      //     message: 'Giảm 20% cho tất cả đồ dùng học tập ',
      //     timestamp: DateTime.now().toIso8601String(),
      //     type: 'promotion',
      //     discount: 20.0,
      //     endDate: DateTime(2025, 5, 17, 11, 59, 00).toIso8601String(),
      //     key: 3,
      //     id: 2,
      //   ),
      // );
      // // Thêm thông báo giảm giá mới
      // await _database.notificationDao.insertNotification(
      //   Notifications(
      //     title: 'Khuyến mãi đặc biệt',
      //     message: 'Giảm 15% cho tất cả đồ uống ',
      //     timestamp: DateTime.now().toIso8601String(),
      //     type: 'promotion',
      //     discount: 15.0,
      //     endDate: DateTime(2025, 5, 18, 8, 00, 00).toIso8601String(),
      //     key: 4,
      //     id: 3,
      //   ),
      // );
    }

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
              ? const Center(child: Text('Chưa có thông báo nào.'))
              : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(
                        _getIconForType(notification.type),
                        color: Colors.blue,
                      ),
                      title: Text(notification.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification.message),
                          if (notification.discount != null)
                            Text(
                              'Giảm ${notification.discount}%',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                      onTap: () {
                        if (notification.type == 'promotion' &&
                            notification.key != null) {
                          Navigator.pop(context, {
                            'category': {
                              'label':
                                  notification.id == 0 
                                      ? 'Mì - Cháo Ăn liền'
                                      : 'Đồ uống',
                            },
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã nhấn: ${notification.title}'),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'promotion':
        return Icons.local_offer;
      case 'cart':
        return Icons.shopping_cart;
      default:
        return Icons.info;
    }
  }
}
