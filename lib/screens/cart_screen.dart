import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';

class CartScreen extends StatefulWidget {
  final List<Product> cartItems;

  const CartScreen({required this.cartItems});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Product> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.cartItems); // Tạo bản sao có thể cập nhật
  }

 void _incrementQuantity(int index) {
  setState(() {
    final item = _cartItems[index];
    _cartItems[index] = item.copyWith(quantity: item.quantity + 1);
  });
}

void _decrementQuantity(int index) {
  setState(() {
    final item = _cartItems[index];
    if (item.quantity > 1) {
      _cartItems[index] = item.copyWith(quantity: item.quantity - 1);
    } else {
      _cartItems.removeAt(index);
    }
  });
}


  @override
  Widget build(BuildContext context) {
    double deliveryFee = 25.0;
    double discount = 0.0;

    double subTotal = _cartItems.fold(
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
                itemCount: _cartItems.length,
                itemBuilder: (context, index) {
                  final item = _cartItems[index];
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
                          Expanded(
                            child: Column(
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
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () => _decrementQuantity(index),
                              ),
                              Text(
                                '${item.quantity}',
                                style: TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => _incrementQuantity(index),
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
