import 'package:flutter/material.dart';
import 'product_manager_screen.dart';
import 'odermanager_screen.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ProductManagementScreen(),
    OrderManagementScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        // Các thuộc tính thêm vào để làm nổi bật item được chọn
        selectedItemColor: Colors.blue, // Màu khi được chọn
        unselectedItemColor: Colors.grey, // Màu khi không được chọn
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold, // Chữ in đậm khi được chọn
        ),
        showUnselectedLabels: true, // Luôn hiển thị nhãn
        type:
            BottomNavigationBarType
                .fixed, // Kiểu fixed để các item không bị thu nhỏ
        elevation: 10, // Độ nổi của thanh điều hướng
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            activeIcon: Icon(Icons.list, size: 28), // Icon lớn hơn khi active
            label: "Quản lý sản phẩm",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            activeIcon: Icon(
              Icons.shopping_cart,
              size: 28,
            ), // Icon lớn hơn khi active
            label: "Quản lý đơn hàng",
          ),
        ],
      ),
    );
  }
}
