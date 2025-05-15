import 'package:flutter/material.dart';
import 'package:grocery_app/screens/home.dart'; // Màn hình chính
import 'package:grocery_app/screens/cart_screen.dart'; // Màn hình giỏ hàng
import 'package:grocery_app/screens/account_screen.dart'; // Màn hình tài khoản
import 'package:grocery_app/models/product.dart'; // Mô hình sản phẩm

class MyBottom extends StatefulWidget {
  final String userEmail;

  const MyBottom({super.key, required this.userEmail});

  @override
  State<StatefulWidget> createState() => _MyBottomState();
}

class _MyBottomState extends State<MyBottom> {
  int _selected = 0; // Màn hình hiện tại
  List<Product> cartProducts = []; // Giỏ hàng

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      Home(onAddToCart: _addToCart), // Truyền hàm thêm vào giỏ hàng
      CartScreen(
        cartItems: cartProducts,
      ), // Truyền giỏ hàng vào màn hình giỏ hàng
      AccountScreen(email: widget.userEmail), // Màn hình tài khoản
    ];
  }

  // Hàm thêm sản phẩm vào giỏ hàng
  void _addToCart(Product product) {
  setState(() {
    final index = cartProducts.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      // Nếu đã có sản phẩm => tăng số lượng
      final updatedProduct = cartProducts[index].copyWith(
        quantity: cartProducts[index].quantity + 1,
      );
      cartProducts[index] = updatedProduct;
      debugPrint('[CART] Tăng số lượng: ${updatedProduct.toString()}');
    } else {
      // Nếu chưa có => thêm mới với quantity = 1
      final newProduct = product.copyWith(quantity: 1);
      cartProducts.add(newProduct);
      debugPrint('[CART] Thêm mới: ${newProduct.toString()}');
    }

    _debugCartContents(); // In log toàn bộ giỏ hàng
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('${product.name} đã được thêm vào giỏ hàng')),
  );
}
void _debugCartContents() {
  debugPrint('------ Danh sách giỏ hàng hiện tại ------');
  for (var item in cartProducts) {
    debugPrint('${item.toString()}');
  }
  debugPrint('----------------------------------------');
}



  // Hàm xử lý sự kiện khi người dùng chuyển tab
  void _onPress(int index) {
    setState(() {
      _selected = index; // Cập nhật màn hình hiện tại
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selected], // Hiển thị màn hình tương ứng với tab đã chọn
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selected, // Hiển thị tab hiện tại
        onTap: _onPress, // Sự kiện khi người dùng chọn tab
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart),
                if (cartProducts.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        cartProducts.length.toString(),
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            label: "Cart",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // Tiêu đề của AppBar thay đổi khi người dùng chuyển tab
  String _getAppBarTitle() {
    switch (_selected) {
      case 0:
        return "Home";
      case 1:
        return "Cart"; // Cập nhật tiêu đề cho tab giỏ hàng
      case 2:
        return "Profile";
      default:
        return "";
    }
  }
}
