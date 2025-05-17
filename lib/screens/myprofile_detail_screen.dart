import 'package:flutter/material.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/models/user.dart';
import 'package:grocery_app/database/database_provider.dart';

class MyDetailScreen extends StatefulWidget {
  final String email;

  const MyDetailScreen({super.key, required this.email});

  @override
  _MyDetailScreenState createState() => _MyDetailScreenState();
}

class _MyDetailScreenState extends State<MyDetailScreen> {
  AppDatabase? _database;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  _loadDatabase() async {
    _database = await DatabaseProvider.database;
    _loadUserData();
  }

  _loadUserData() async {
    User? user = await _database!.userDao.getUserByEmail(widget.email);

    setState(() {
      _user = user;
    });

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No user found with email ${widget.email}")),
      );
    }
  }

  void _editUser() {
    final TextEditingController nameController = TextEditingController(
      text: _user?.name,
    );
    final TextEditingController emailController = TextEditingController(
      text: _user?.email,
    );
    final TextEditingController phoneController = TextEditingController(
      text: _user?.phone,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit User Details'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Cập nhật thông tin người dùng
                _updateUser(
                  nameController.text,
                  emailController.text,
                  phoneController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateUser(String name, String email, String phone) async {
    if (_user != null) {
      _user!.name = name;
      _user!.email = email;
      _user!.phone = phone;

      await _database!.userDao.updateUser(_user!);
      setState(() {}); // Cập nhật lại giao diện
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child:
            _user == null
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(
                            "assets/images/douong_redbull.png",
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tên người dùng
                      Center(
                        child: Text(
                          _user!.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Thông tin email
                      _buildDetailRow('Email', _user!.email),
                      const SizedBox(height: 16),

                      // Thông tin số điện thoại
                      _buildDetailRow('Phone', _user!.phone),
                      const SizedBox(height: 32),

                      // Nút chỉnh sửa
                      Center(
                        child: ElevatedButton(
                          onPressed: _editUser, // Gọi sự kiện chỉnh sửa
                          child: const Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              37,
                              214,
                              131,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  // Widget hỗ trợ hiển thị thông tin chi tiết (label, giá trị)
  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
