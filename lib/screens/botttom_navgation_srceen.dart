import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/models/cart.dart';
import 'package:grocery_app/screens/home.dart';
import 'package:grocery_app/screens/cart_screen.dart';
import 'package:grocery_app/screens/order_stats_screen.dart';
import 'package:grocery_app/screens/product_manager_screen.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/database/database_provider.dart';

class MyBottom extends StatefulWidget {
  final String userName;

  const MyBottom({super.key, required this.userName});

  @override
  State<MyBottom> createState() => _MyBottomState();
}

class _MyBottomState extends State<MyBottom> {
  int _selected = 0;
  List<CartItem> cartProducts = [];
  late AppDatabase _database;
  String? _snackBarMessage; // Biến trạng thái để lưu thông báo

  late final List<Widget Function()> _screenBuilders;

  @override
  void initState() {
    super.initState();
    _screenBuilders = [
      () => Home(onAddToCart: _addToCart),
      () => CartScreen(cartItems: cartProducts),
      () => ProductManagementScreen(),
      () => RevenueStatisticsScreen(),
    ];

    // Chạy các tác vụ bất đồng bộ sau khi widget được gắn
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initDatabaseAndLoadCart();
    });
  }

  Future<void> _initDatabaseAndLoadCart() async {
    await _initDatabase();
    await _loadCartProducts();
  }

  Future<void> _initDatabase() async {
    _database = await DatabaseProvider.database;
  }

  Future<void> _loadCartProducts() async {
    try {
      final loadedCartItems = await _database.cartItemDao.getAllCartItems();
      setState(() {
        cartProducts = loadedCartItems;
      });
    } catch (e) {
      setState(() {
        _snackBarMessage = 'Lỗi khi tải giỏ hàng: $e';
      });
    }
  }

  Future<void> _addToCart(Product product) async {
    try {
      final existingCartItem = cartProducts.firstWhere(
        (item) => item.productId == product.id,
        orElse:
            () => CartItem(
              id: null,
              productId: product.id!,
              productName: product.name,
              price: product.price,
              imgURL: product.imgURL,
              quantity: 0,
              discount: product.discount,
            ),
      );

      if (existingCartItem.quantity > 0) {
        final updatedCartItem = CartItem(
          id: existingCartItem.id,
          productId: existingCartItem.productId,
          productName: existingCartItem.productName,
          price: existingCartItem.price,
          imgURL: existingCartItem.imgURL,
          quantity: existingCartItem.quantity + 1,
          discount: existingCartItem.discount,
        );
        await _database.cartItemDao.updateCartItem(updatedCartItem);
        print(
          'Cập nhật CartItem: ${updatedCartItem.productName}, Số lượng: ${updatedCartItem.quantity}',
        );
        setState(() {
          _snackBarMessage = '${product.name} đã được cập nhật trong giỏ hàng';
        });
      } else {
        final newCartItem = CartItem(
          productId: product.id!,
          productName: product.name,
          price: product.price,
          imgURL: product.imgURL,
          quantity: 1,
          discount: product.discount,
        );
        await _database.cartItemDao.insertCartItem(newCartItem);
        print(
          'Thêm mới CartItem: ${newCartItem.productName}, Số lượng: ${newCartItem.quantity}',
        );
        setState(() {
          _snackBarMessage = '${product.name} đã được thêm vào giỏ hàng';
        });
      }

      await _loadCartProducts();
    } catch (e) {
      setState(() {
        _snackBarMessage = 'Lỗi khi thêm vào giỏ hàng: $e';
      });
    }
  }

  void _onPress(int index) {
    setState(() {
      _selected = index;
    });
    if (index == 1) {
      _loadCartProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hiển thị SnackBar dựa trên _snackBarMessage
    if (_snackBarMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_snackBarMessage!)));
        setState(() {
          _snackBarMessage = null; // Xóa thông báo sau khi hiển thị
        });
      });
    }

    return Scaffold(
      body: _screenBuilders[_selected](),
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
          const BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Chart",
          ),
        ],
      ),
    );
  }
}

// Thêm extension để hỗ trợ copyWith cho CartItem
extension CartItemExtension on CartItem {
  CartItem copyWith({
    int? id,
    int? productId,
    String? productName,
    double? price,
    String? imgURL,
    int? quantity,
    double? discount,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      imgURL: imgURL ?? this.imgURL,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
    );
  }
}
