import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';

class CartScreen extends StatefulWidget {
  final List<Product> cartItems; // Nhận giỏ hàng từ HomeScreen

  CartScreen({required this.cartItems, required List cartProducts}); // Sử dụng tham số cartItems

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double deliveryFee = 25.0; // Phí giao hàng
  double discount = 0.0; // Giảm giá (nếu có)

  // Tính tổng giá trị giỏ hàng
  double get subTotal {
    return widget.cartItems.fold(0.0, (total, item) => total + (item.price * item.quantity));
  }

  // Cập nhật số lượng sản phẩm trong giỏ hàng
  void _updateQuantity(Product product, int delta) {
    setState(() {
      product.quantity += delta;
      if (product.quantity < 1) product.quantity = 1; // Đảm bảo số lượng không nhỏ hơn 1
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ Hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.asset(item.imgURL, width: 80, height: 80, fit: BoxFit.cover),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text('Price: ${item.price} đ'),
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () => _updateQuantity(item, -1),
                              ),
                              Text('${item.quantity}', style: TextStyle(fontSize: 16)),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => _updateQuantity(item, 1),
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
                Text('Total Cost:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${(subTotal + deliveryFee - discount).toStringAsFixed(3)} đ'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Xử lý thanh toán
              },
              child: Text('Proceed to Checkout'),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}
