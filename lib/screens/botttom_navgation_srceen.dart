import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';
import 'home.dart';
import 'favourite_screen.dart';
import 'CartScreen.dart';

class MyBottom extends StatefulWidget {
  const MyBottom({super.key});

  @override
  State<StatefulWidget> createState() => _MyBottomState();
}

class _MyBottomState extends State<MyBottom> {
  int _selected = 0;

  // Khởi tạo danh sách yêu thích với danh sách trống
  List<Product> favoriteItems = []; // Danh sách yêu thích

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      const Home(),
      FavoriteScreen(
        favoriteItems: favoriteItems, // Truyền danh sách yêu thích
        onRemoveFavorite: (Product product) {
          setState(() {
            favoriteItems.remove(product); // Cập nhật danh sách yêu thích khi xóa sản phẩm
          });
        },
      ),
      CartScreen(cartItems: [], cartProducts: [],), // Truyền giỏ hàng vào CartScreen
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getAppBarTitle())), // Đặt tiêu đề cho AppBar dựa trên màn hình hiện tại
      body: _screens[_selected], // Hiển thị màn hình đã chọn
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selected,
        onTap: _onPress,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
        ],
      ),
    );
  }

  // Hàm để thay đổi tiêu đề AppBar tùy vào màn hình hiện tại
  String _getAppBarTitle() {
    switch (_selected) {
      case 0:
        return 'Home';
      case 1:
        return 'Favorite';
      case 2:
        return 'Cart';
      default:
        return '';
    }
  }

  // Hàm xử lý sự kiện khi chọn item trong BottomNavigationBar
  void _onPress(int index) {
    setState(() {
      _selected = index;  // Cập nhật màn hình được chọn
    });
  }
}
