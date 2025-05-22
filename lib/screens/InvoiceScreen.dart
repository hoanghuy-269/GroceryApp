import 'package:flutter/material.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/database/database_provider.dart';
import 'package:grocery_app/models/cart.dart';
import 'package:grocery_app/models/order_item.dart';
import 'package:grocery_app/dao/product_dao.dart';
import 'package:grocery_app/models/order.dart';
import 'package:grocery_app/screens/botttom_navgation_srceen.dart';
import 'package:intl/intl.dart';

class InvoiceScreen extends StatefulWidget {
  final List<CartItem> products;

  const InvoiceScreen({Key? key, required this.products}) : super(key: key);

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  late AppDatabase _database;
  final DateTime orderTime = DateTime(
    2025,
    5,
    21,
    23,
    57,
  ); // 11:57 PM, 21/05/2025

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await DatabaseProvider.database;
  }

  double get totalAmount => widget.products.fold(
    0.0,
    (sum, item) => sum + item.price * item.quantity,
  );

  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(value);
  }

  Future<void> _completeOrder() async {
    try {
      final total = totalAmount;

      // Tạo đơn hàng mới
      final order = Order(id: null, orderDate: orderTime, totalAmount: total);

      // Chèn đơn hàng và nhận ID
      final orderId = await _database.orderDao.insertOrder(order);

      final orderItems =
          widget.products.map((cartItem) {
            return OrderItem(
              id: null,
              orderId: orderId, // Sử dụng orderId đã nhận
              productId: cartItem.productId,
              quantity: cartItem.quantity,
              price: cartItem.price,
              discount: cartItem.discount,
            );
          }).toList();

      // Thêm các sản phẩm vào bảng OrderItem và cập nhật số lượng sản phẩm
      for (var item in orderItems) {
        await _database.orderItemDao.insertOrderItem(item);

        // Giảm số lượng sản phẩm trong kho
        final product = await _database.productDao.findProductById(
          item.productId,
        );
        if (product != null) {
          final newQuantity = product.quantity - item.quantity;
          await _database.productDao.updateQuantity(
            item.productId,
            newQuantity,
          );
        }
      }

      // Xóa giỏ hàng
      await _database.cartItemDao.deleteAllCartItems();

      // Chuyển sang màn hình chính
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyBottom(userName: "")),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đơn hàng đã được hoàn thành!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hóa Đơn Thanh Toán')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: widget.products.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = widget.products[index];
                  return ListTile(
                    title: Text(item.productName),
                    subtitle: Text('Số lượng: ${item.quantity}'),
                    trailing: Text(
                      formatCurrency(item.price * item.quantity),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Thời gian:'),
                Text(
                  DateFormat('hh:mm a, dd/MM/yyyy').format(orderTime),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const Divider(thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng cộng:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  formatCurrency(totalAmount),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _completeOrder,
              child: const Text('Hoàn Thành'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
