import 'package:flutter/material.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/database/database_provider.dart';
import 'package:grocery_app/models/Customer.dart';
import 'package:grocery_app/models/cart.dart';
import 'package:grocery_app/models/order_item.dart';
import 'package:grocery_app/dao/product_dao.dart';
import 'package:grocery_app/models/order.dart';
import 'package:grocery_app/screens/botttom_navgation_srceen.dart';
import 'package:intl/intl.dart';

class InvoiceScreen extends StatefulWidget {
  final List<CartItem> products;

  const InvoiceScreen({Key? key, required this.products, Customer? customer, required int pointsUsed, required double totalAmount}) : super(key: key);

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  late AppDatabase _database;
  final DateTime orderTime = DateTime.now();

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
    return formatter.format(value * 1000); // Nhân 1000 để hiển thị giá đúng định dạng
  }

  Future<void> _completeOrder() async {
    try {
      final total = totalAmount;

      final order = Order(id: null, orderDate: orderTime, totalAmount: total);
      final orderId = await _database.orderDao.insertOrder(order);

      print('Đơn hàng đã được tạo:');
      print('ID: $orderId');
      print('Ngày: ${order.orderDate}');
      print('Tổng cộng: ${formatCurrency(total)}');

      final orderItems = widget.products.map((cartItem) {
        return OrderItem(
          id: null,
          orderId: orderId,
          productId: cartItem.productId,
          quantity: cartItem.quantity,
          price: cartItem.price,
          discount: cartItem.discount,
        );
      }).toList();

      for (var item in orderItems) {
        await _database.orderItemDao.insertOrderItem(item);

        final product = await _database.productDao.findProductById(item.productId);
        if (product != null) {
          final newQuantity = product.quantity - item.quantity;
          await _database.productDao.updateQuantity(item.productId, newQuantity);
        }
      }

      await _database.cartItemDao.deleteAllCartItems();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyBottom(userName: "")),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đơn hàng đã được hoàn thành!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hóa Đơn Thanh Toán'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: widget.products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = widget.products[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Số lượng: ${item.quantity}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            formatCurrency(item.price * item.quantity),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng cộng:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatCurrency(totalAmount),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Thời gian đặt:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        DateFormat('hh:mm a, dd/MM/yyyy').format(orderTime),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng cộng:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _completeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 6,
                ),
                child: const Text(
                  'Hoàn Thành',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
