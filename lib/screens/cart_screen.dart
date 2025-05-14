import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';

class CartScreen extends StatelessWidget {
  final List<Product> cartItems; // Nhận giỏ hàng từ HomeScreen

  const CartScreen({required this.cartItems}); // Thêm tham số cartItems

  @override
  Widget build(BuildContext context) {
    double deliveryFee = 25.0; // Phí giao hàng
    double discount = 0.0; // Giảm giá (nếu có)

    // Tính tổng giá trị giỏ hàng
    double subTotal = cartItems.fold(
      0.0,
      (total, item) => total + (item.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Giỏ Hàng')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.asset(
                            item.imgURL,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Price: ${item.price} đ'),
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  // Cập nhật số lượng
                                },
                              ),
                              Text(
                                '${item.quantity}',
                                style: TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  // Cập nhật số lượng
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sub-Total:', style: TextStyle(fontSize: 16)),
                Text('${subTotal.toStringAsFixed(3)} đ'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery Fee:', style: TextStyle(fontSize: 16)),
                Text('${deliveryFee.toStringAsFixed(3)} đ'),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Cost:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${(subTotal + deliveryFee - discount).toStringAsFixed(3)} đ',
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Xử lý thanh toán
              },
              child: Text('Proceed to Checkout'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
