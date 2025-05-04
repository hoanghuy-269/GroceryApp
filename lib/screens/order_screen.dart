import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Danh sách các đơn hàng
  final List<Map<String, dynamic>> orders = [
    {
      'id': 'Order #1',
      'date': '2023-05-01',
      'total': 45.99,
      'status': 'Completed',
    },
    {
      'id': 'Order #2',
      'date': '2023-05-05',
      'total': 30.00,
      'status': 'Pending',
    },
    {
      'id': 'Order #3',
      'date': '2023-05-10',
      'total': 25.50,
      'status': 'Shipped',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders History')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return _buildOrderTile(
              order['id'],
              order['date'],
              order['total'],
              order['status'],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderTile(
    String orderId,
    String date,
    double total,
    String status,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(orderId),
        subtitle: Text(
          'Date: $date\nTotal: \$${total.toStringAsFixed(2)}\nStatus: $status',
        ),
        onTap: () {
          // Điều hướng đến màn hình chi tiết đơn hàng
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => OrderDetailScreen(
                    orderId: orderId,
                    date: date,
                    total: total,
                    status: status,
                  ),
            ),
          );
        },
      ),
    );
  }
}

// Màn hình chi tiết đơn hàng
class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  final String date;
  final double total;
  final String status;

  const OrderDetailScreen({
    super.key,
    required this.orderId,
    required this.date,
    required this.total,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(orderId)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Order ID: $orderId'),
            Text('Date: $date'),
            Text('Total: \$${total.toStringAsFixed(2)}'),
            Text('Status: $status'),
            const SizedBox(height: 24),
            // Thêm thông tin chi tiết khác nếu cần
          ],
        ),
      ),
    );
  }
}
