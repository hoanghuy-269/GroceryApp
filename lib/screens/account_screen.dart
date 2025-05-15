import 'package:flutter/material.dart';
import 'package:grocery_app/screens/myprofile_detail_screen.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:grocery_app/models/user.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/screens/purchase_history_sreen.dart';

class AccountScreen extends StatefulWidget {
  final String email;

  const AccountScreen({super.key, required this.email});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User? _user;
  AppDatabase? _database;

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  _loadDatabase() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _loadUserData();
  }

  _loadUserData() async {
    User? user = await _database!.userDao.getUserByEmail(widget.email);

    setState(() {
      _user = user;
    });

    if (user == null) {
      print("No user found with email ${widget.email}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No user found with email ${widget.email}")),
      );
    } else {
      print("User phone: ${user.phone}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _user == null ? 'Chưa có thông tin người dùng' : _user!.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildListTile(Icons.list, 'Orders'),
                  _buildListTile(Icons.person, 'My Details', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MyDetailScreen(email: widget.email),
                      ),
                    ).then((_) {
                      // Gọi lại _loadUserData khi quay lại từ MyDetailScreen
                      _loadUserData();
                    });
                  }),
                  _buildListTile(Icons.delivery_dining, 'Delivery Access'),
                  _buildListTile(Icons.payment, 'Payment Methods', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PurchaseHistoryPage(),
                      ),
                    );
                  }),
                  _buildListTile(Icons.card_giftcard, 'Promo Card'),
                  _buildListTile(Icons.notifications, 'Notifications'),
                  _buildListTile(Icons.help, 'Help'),
                  _buildListTile(Icons.info, 'About'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Xác nhận đăng xuất'),
                      content: const Text(
                        'Bạn có chắc chắn muốn đăng xuất không?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text('Đăng xuất'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blueAccent,
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
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, [Function()? onTap]) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        onTap: onTap,
      ),
    );
  }
}
