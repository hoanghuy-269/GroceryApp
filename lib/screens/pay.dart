import 'package:flutter/material.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/database/database_provider.dart';
import 'package:grocery_app/models/cart.dart';
import 'package:grocery_app/models/Customer.dart';
import 'package:grocery_app/dao/customer_dao.dart';
import 'package:grocery_app/screens/InvoiceScreen.dart';

class PayScreen extends StatefulWidget {
  final double totalAmount;
  final List<CartItem> products;
  final Customer? customer;
  final int? pointsUsed;

  const PayScreen({
    super.key,
    required this.totalAmount,
    required this.products,
    this.customer,
    this.pointsUsed,
  });

  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  late AppDatabase _database;
  late CustomerDao _customerDao;
  Customer? _selectedCustomer;
  int _pointsUsed = 0;
  double _discountFromPoints = 0.0;
  late double _finalTotal;

  @override
  void initState() {
    super.initState();
    _finalTotal = widget.totalAmount; // Khởi tạo với totalAmount từ CartScreen
    _selectedCustomer = widget.customer;
    _pointsUsed = widget.pointsUsed ?? 0;
    _discountFromPoints =
        _pointsUsed *
        (widget.totalAmount / 100.0); // Tính giảm giá nếu đã dùng điểm
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await DatabaseProvider.database;
    _customerDao = _database.customerDao;
  }

  // Dialog chọn khách hàng
  Future<void> _showSelectCustomerDialog() async {
    final customers = await _customerDao.getAllCustomers();
    if (customers.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Không có khách hàng nào")));
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Chọn khách hàng"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return ListTile(
                  subtitle: Text("Điểm: ${customer.points}"),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showUsePointsDialog(customer);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Hủy"),
            ),
          ],
        );
      },
    );
  }

  // Dialog nhập số điểm
  Future<void> _showUsePointsDialog(Customer customer) async {
    final pointsController = TextEditingController();
    final subTotal =
        widget.totalAmount +
        _discountFromPoints; // Lấy lại subTotal trước khi giảm

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Sử dụng điểm"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Khách hàng: ${customer.name}"),
              Text("Điểm: ${customer.points}"),
              Text("Hóa đơn: ${subTotal.toStringAsFixed(0)} VNĐ"),
              TextField(
                controller: pointsController,
                decoration: InputDecoration(labelText: "Số điểm"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                final pointsToUse = int.tryParse(pointsController.text);
                if (pointsToUse == null || pointsToUse <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Nhập số điểm hợp lệ")),
                  );
                  return;
                }
                if (pointsToUse > customer.points) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Không đủ điểm")));
                  return;
                }
                double discount =
                    subTotal * (pointsToUse / 100.0); // 1 điểm = 1% giảm
                if (discount > subTotal) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Điểm vượt quá hóa đơn")),
                  );
                  return;
                }
                await _applyPoints(customer, pointsToUse, discount);
                Navigator.of(context).pop();
              },
              child: Text("Áp dụng"),
            ),
          ],
        );
      },
    );
  }

  // Áp dụng điểm
  Future<void> _applyPoints(
    Customer customer,
    int pointsToUse,
    double discount,
  ) async {
    setState(() {
      _selectedCustomer = customer;
      _discountFromPoints = discount;
      _pointsUsed = pointsToUse;
      _finalTotal =
          widget.totalAmount +
          _discountFromPoints -
          discount; // Cập nhật tổng tiền
    });

    final updatedCustomer = Customer(
      id: customer.id,
      name: customer.name,
      phone: customer.phone,
      points: customer.points - pointsToUse,
    );
    await _customerDao.updateCustomer(updatedCustomer);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Giảm ${discount.toStringAsFixed(0)} VNĐ")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh Toán')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            if (_selectedCustomer != null && _pointsUsed > 0)
              Column(
                children: [
                  Text(
                    'Khách hàng: ${_selectedCustomer!.name}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Điểm sử dụng: $_pointsUsed',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Giảm giá: ${_discountFromPoints.toStringAsFixed(0)} VNĐ',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            const Text(
              'Tổng số tiền cần thanh toán:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              '${_finalTotal.toStringAsFixed(0)} đ',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 40),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => InvoiceScreen(
                          products: widget.products,
                          customer: _selectedCustomer, // Truyền khách hàng
                          pointsUsed: _pointsUsed, // Truyền điểm đã sử dụng
                          totalAmount: _finalTotal, // Truyền tổng tiền sau giảm
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Thanh Toán Ngay'),
            ),
          ],
        ),
      ),
    );
  }
}
