import 'package:flutter/material.dart';
import 'package:grocery_app/database/app_database.dart'; // Đảm bảo rằng import đúng
import 'package:grocery_app/models/user.dart'; // Đảm bảo rằng import đúng

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  // Gọi phương thức để in tất cả người dùng ra console khi widget được tạo
  @override
  void initState() {
    super.initState();
    printAllUsers(); // Gọi phương thức này trong initState
  }

  Future<void> printAllUsers() async {
    // Lấy đối tượng cơ sở dữ liệu
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    // Lấy danh sách người dùng từ cơ sở dữ liệu
    List<User> users = await database.userDao.getAllUsers();

    // In danh sách người dùng ra console
    users.forEach((user) {
      print(
        'User: ${user.name}, Email: ${user.email}, Phone: ${user.phone}, ${user.password}, ${user.role}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User List')),
      body: Center(child: Text('Check console for user data!')),
    );
  }
}
