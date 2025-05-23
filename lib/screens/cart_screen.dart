import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/database/database_provider.dart';
import 'package:grocery_app/models/cart.dart';
import 'package:grocery_app/models/Customer.dart';
import 'package:grocery_app/dao/customer_dao.dart';
import 'package:grocery_app/screens/pay.dart';

// Màn hình hiển thị giỏ hàng, nhận danh sách sản phẩm (cartItems) từ widget cha
class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems; // Danh sách các sản phẩm trong giỏ hàng

  const CartScreen({super.key, required this.cartItems});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> _cartItems;
  late AppDatabase _database;
  late CustomerDao _customerDao;
  Customer? _selectedCustomer;
  double _discountFromPoints = 0.0;
  int _pointsUsed = 0;

  @override
  void initState() {
    super.initState();
    // Khởi tạo danh sách sản phẩm từ widget cha
    _cartItems = List.from(widget.cartItems);
    // Khởi tạo cơ sở dữ liệu
    _initDatabase();
  }

  // Hàm khởi tạo cơ sở dữ liệu và DAO
  Future<void> _initDatabase() async {
    _database = await DatabaseProvider.database; // Lấy instance của AppDatabase
    _customerDao = _database.customerDao; // Lấy instance của CustomerDao
  }

  // Hàm tăng số lượng sản phẩm trong giỏ hàng
  void _incrementQuantity(int index) async {
    final item = _cartItems[index];

    try {
      // Lấy thông tin sản phẩm tương ứng từ DB theo productId
      final product = await _database.productDao.findProductById(
        item.productId,
      );

      if (product == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sản phẩm không tồn tại')));
        return;
      }

      if (item.quantity < product.quantity) {
        setState(() {
          _cartItems[index] = CartItem(
            id: item.id,
            productId: item.productId,
            productName: item.productName,
            price: item.price,
            imgURL: item.imgURL,
            quantity: item.quantity + 1,
            discount: item.discount,
          );
        });

        await _database.cartItemDao.updateCartItem(_cartItems[index]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã đạt số lượng tối đa trong kho')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi cập nhật giỏ hàng')));
    }
  }

  // Hàm giảm số lượng sản phẩm trong giỏ hàng
  void _decrementQuantity(int index) async {
    final item = _cartItems[index];
    if (item.quantity > 1) {
      setState(() {
        // Tạo mới CartItem với số lượng giảm đi 1
        _cartItems[index] = CartItem(
          id: item.id,
          productId: item.productId,
          productName: item.productName,
          price: item.price,
          imgURL: item.imgURL,
          quantity: item.quantity - 1,
          discount: item.discount,
        );
      });
      try {
        // Cập nhật sản phẩm trong cơ sở dữ liệu
        await _database.cartItemDao.updateCartItem(_cartItems[index]);
      } catch (e) {
        // Hiển thị thông báo lỗi nếu cập nhật thất bại
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi cập nhật giỏ hàng')));
      }
    } else {
      // Nếu số lượng bằng 1, xóa sản phẩm khỏi giỏ hàng
      setState(() {
        _cartItems.removeAt(index);
      });
      try {
        // Xóa sản phẩm khỏi cơ sở dữ liệu
        await _database.cartItemDao.deleteCartItem(item);
      } catch (e) {
        // Hiển thị thông báo lỗi nếu xóa thất bại
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi xóa sản phẩm')));
      }
    }
  }

  // Hiển thị dialog để chọn khách hàng
  Future<void> _showSelectCustomerDialog() async {
    // Lấy danh sách khách hàng từ cơ sở dữ liệu
    final customers = await _customerDao.getAllCustomers();
    if (customers.isEmpty) {
      // Hiển thị thông báo nếu không có khách hàng
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Không có khách hàng nào")));
      return;
    }

    // Hiển thị dialog chứa danh sách khách hàng
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
                  title: Text(customer.name ?? ''), // Tên khách hàng
                  subtitle: Text("Điểm: ${customer.points}"), // Điểm tích lũy
                  onTap: () {
                    Navigator.of(context).pop(); // Đóng dialog
                    _showUsePointsDialog(customer); // Mở dialog sử dụng điểm
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Đóng dialog
              child: Text("Hủy"),
            ),
          ],
        );
      },
    );
  }

  // Hiển thị dialog để nhập số điểm muốn sử dụng
  Future<void> _showUsePointsDialog(Customer customer) async {
    final pointsController =
        TextEditingController(); // Controller cho TextField nhập điểm
    // Tính tổng tiền trước giảm giá
    final subTotal = _cartItems.fold(
      0.0,
      (total, item) =>
          total +
          item.price * item.quantity -
          (item.discount ?? 0.0) * item.quantity,
    );

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Sử dụng điểm"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Khách hàng: ${customer.name}"), // Tên khách hàng
              Text("Điểm: ${customer.points}"), // Điểm hiện có
              Text(
                "Hóa đơn: ${subTotal.toStringAsFixed(0)} VNĐ",
              ), // Tổng tiền hóa đơn
              TextField(
                controller: pointsController,
                decoration: InputDecoration(
                  labelText: "Số điểm",
                ), // Nhập số điểm
                keyboardType: TextInputType.number, // Bàn phím số
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Đóng dialog
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                final pointsToUse = int.tryParse(
                  pointsController.text,
                ); // Lấy số điểm nhập vào
                if (pointsToUse == null || pointsToUse <= 0) {
                  // Kiểm tra số điểm hợp lệ
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Nhập số điểm hợp lệ")),
                  );
                  return;
                }
                if (pointsToUse > customer.points) {
                  // Kiểm tra nếu số điểm vượt quá điểm hiện có
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Không đủ điểm")));
                  return;
                }
                // 1 điểm = 1% giảm giá
                double discount = subTotal * (pointsToUse * 0.1);
                if (discount > subTotal) {
                  // Kiểm tra nếu giảm giá vượt quá tổng hóa đơn
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Điểm vượt quá hóa đơn")),
                  );
                  return;
                }
                // Áp dụng điểm và cập nhật trạng thái
                await _applyPoints(customer, pointsToUse, discount);
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text("Áp dụng"),
            ),
          ],
        );
      },
    );
  }

  // Hàm áp dụng điểm để giảm giá
  Future<void> _applyPoints(
    Customer customer,
    int pointsToUse,
    double discount,
  ) async {
    setState(() {
      _selectedCustomer = customer; // Lưu khách hàng đã chọn
      _discountFromPoints = discount; // Lưu số tiền giảm giá
      _pointsUsed = pointsToUse; // Lưu số điểm đã dùng
    });

    // Cập nhật điểm của khách hàng trong cơ sở dữ liệu
    final updatedCustomer = Customer(
      id: customer.id,
      name: customer.name,
      phone: customer.phone,
      points: customer.points - pointsToUse,
    );
    await _customerDao.updateCustomer(updatedCustomer);

    // Hiển thị thông báo giảm giá
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Giảm ${discount.toStringAsFixed(0)} VNĐ")),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tính tổng tiền trước giảm giá
    final subTotal = _cartItems.fold(
      0.0,
      (total, item) =>
          total +
          item.price * item.quantity -
          (item.discount ?? 0.0) * item.quantity,
    );
    // Tính tổng tiền sau giảm giá
    final totalCost = subTotal - _discountFromPoints;

    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ Hàng')), // Tiêu đề màn hình
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Kiểm tra nếu giỏ hàng trống
            _cartItems.isEmpty
                ? Expanded(
                  child: Center(
                    child: Text(
                      'Giỏ hàng trống',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ),
                )
                : Expanded(
                  // Hiển thị danh sách sản phẩm trong giỏ hàng
                  child: ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              // Hiển thị ảnh sản phẩm
                              _buildProductImage(item.imgURL),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Tên sản phẩm
                                    Text(
                                      item.productName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Giá sản phẩm
                                    Text(
                                      'Price: ${item.price.toStringAsFixed(0)} đ',
                                    ),
                                    // Hiển thị giảm giá nếu có
                                    if (item.discount != null &&
                                        item.discount! > 0)
                                      Text(
                                        'Discount: ${(item.discount! * item.quantity).toStringAsFixed(0)} đ',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                  ],
                                ),
                              ),
                              // Nút tăng/giảm số lượng
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () => _decrementQuantity(index),
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
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
            const Divider(), // Đường phân cách
            // Hiển thị tổng tiền trước giảm giá
            _buildPriceRow('Sub-Total:', subTotal),
            // Hiển thị số tiền giảm giá nếu có
            if (_discountFromPoints > 0)
              _buildPriceRow('Giảm giá (Điểm):', _discountFromPoints),
            const Divider(),
            // Hiển thị tổng tiền sau giảm giá
            _buildPriceRow('Total Cost:', totalCost, isTotal: true),
            const SizedBox(height: 10),
            // Nút mở dialog chọn khách hàng
            ElevatedButton(
              onPressed: _showSelectCustomerDialog,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Sử dụng điểm'),
            ),
            const SizedBox(height: 10),
            // Nút chuyển sang màn hình thanh toán
            ElevatedButton(
              onPressed:
                  _cartItems.isEmpty
                      ? null
                      : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => PayScreen(
                                  totalAmount: totalCost, // Tổng tiền
                                  products: _cartItems, // Danh sách sản phẩm
                                  customer: _selectedCustomer, // Khách hàng
                                  pointsUsed: _pointsUsed, // Điểm đã sử dụng
                                ),
                          ),
                        );
                      },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Thanh toán'),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm tạo widget hiển thị dòng giá (Sub-Total, Discount, Total Cost)
  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16, // Kích thước chữ lớn hơn cho Total
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${amount.toStringAsFixed(0)} đ',
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String imgURL) {
    final file = File(imgURL);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child:
          file.existsSync()
              ? Image.file(
                file,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => const Icon(Icons.broken_image, size: 80),
              )
              : const Icon(Icons.broken_image, size: 80),
    );
  }
}
