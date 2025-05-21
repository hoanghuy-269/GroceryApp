import 'package:flutter/material.dart';
import 'package:grocery_app/screens/home.dart';
import 'package:grocery_app/screens/cart_screen.dart';
import 'package:grocery_app/screens/product_manager_screen.dart';
import 'package:grocery_app/models/product.dart';

class MyBottom extends StatefulWidget {
  final String userName;

  const MyBottom({super.key, required this.userName});

  @override
  State<MyBottom> createState() => _MyBottomState();
}

class _MyBottomState extends State<MyBottom> {
  int _selected = 0;
  List<Product> cartProducts = [];

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      Home(onAddToCart: _addToCart),
      CartScreen(cartItems: cartProducts),
      ProductManagementScreen(),
    ];
  }

  void _addToCart(Product product) {
    setState(() {
      final index = cartProducts.indexWhere((item) => item.id == product.id);
      if (index != -1) {
        cartProducts[index] = cartProducts[index].copyWith(
          quantity: cartProducts[index].quantity + 1,
        );
      } else {
        cartProducts.add(product.copyWith(quantity: 1));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} đã được thêm vào giỏ hàng')),
    );
  }

  void _onPress(int index) {
    setState(() {
      _selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selected],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selected,
        onTap: _onPress,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cartProducts.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        cartProducts.length.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: "Cart",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
