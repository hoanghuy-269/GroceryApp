import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin người dùng
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150',
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Mohammed Hashim',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 24),

            Expanded(
              child: ListView(
                children: [
                  _buildListTile(Icons.list, 'Orders'),
                  _buildListTile(Icons.person, 'My Details'),
                  _buildListTile(Icons.delivery_dining, 'Delivery Access'),
                  _buildListTile(Icons.payment, 'Payment Methods'),
                  _buildListTile(Icons.card_giftcard, 'Promo Card'),
                  _buildListTile(Icons.notifications, 'Notifications'),
                  _buildListTile(Icons.help, 'Help'),
                  _buildListTile(Icons.info, 'About'),
                ],
              ),
            ),

            ElevatedButton(
              onPressed: () {
                // Thêm hành động đăng xuất ở đây
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        // Thêm hành động khi nhấn vào mục
      },
    );
  }
}
