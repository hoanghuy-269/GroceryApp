import 'package:flutter/material.dart';
import 'package:floor/floor.dart';
import 'package:grocery_app/models/purchaseHistory.dart';
import 'package:grocery_app/dao/purchasehistory_dao.dart';
import 'package:grocery_app/database/app_database.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({Key? key}) : super(key: key);

  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  late AppDatabase _database;
  late PurchaseHistoryDao _purchaseHistoryDao;
  List<PurchaseHistory> _orders = [];
  bool _isLoading = true;

  final List<String> _statusOptions = [
    'Chờ xác nhận',
    'Đã xác nhận',
    'Đang giao hàng',
    'Đã giao',
    'Đã hủy',
  ];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _purchaseHistoryDao = _database.purchaseHistoryDao;
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);

    try {
      _orders = await _purchaseHistoryDao.getAllOrders();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải đơn hàng: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý đơn hàng"),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadOrders),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _orders.isEmpty
              ? const Center(child: Text("Không có đơn hàng nào"))
              : RefreshIndicator(
                onRefresh: _loadOrders,
                child: ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      elevation: 3,
                      child: ListTile(
                        title: Text(
                          "Đơn hàng #${order.id}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text("Email: ${order.email}"),
                            Text("Sản phẩm: ${order.product}"),
                            Text("Số lượng: ${order.quantity}"),
                            Text(
                              "Tổng tiền: \$${order.total.toStringAsFixed(2)}",
                            ),
                            Text("Ngày đặt: ${order.date}"),
                            Text("Trạng thái: ${order.status}"),
                            const SizedBox(height: 5),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected:
                              (value) => _handlePopupSelection(value, order),
                          itemBuilder:
                              (BuildContext context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Cập nhật trạng thái'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Xóa đơn hàng'),
                                ),
                              ],
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }

  void _handlePopupSelection(String value, PurchaseHistory order) async {
    if (value == 'edit') {
      await _showStatusDialog(order);
    } else if (value == 'delete') {
      await _showDeleteDialog(order);
    }
  }

  Future<void> _showStatusDialog(PurchaseHistory order) async {
    String? selectedStatus = order.status;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Cập nhật trạng thái đơn hàng #${order.id}"),
              content: DropdownButton<String>(
                value: selectedStatus,
                onChanged:
                    (String? newValue) =>
                        setState(() => selectedStatus = newValue),
                items:
                    _statusOptions.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Hủy'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Lưu'),
                  onPressed: () {
                    if (selectedStatus != null &&
                        selectedStatus != order.status) {
                      _updateOrderStatus(order, selectedStatus!);
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updateOrderStatus(
    PurchaseHistory order,
    String newStatus,
  ) async {
    try {
      final updatedOrder = PurchaseHistory(
        id: order.id,
        email: order.email,
        product: order.product,
        quantity: order.quantity,
        total: order.total,
        date: order.date,
        status: newStatus,
      );

      await _purchaseHistoryDao.updatePurchaseHistory(updatedOrder);
      await _loadOrders();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã cập nhật trạng thái đơn hàng #${order.id}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật: ${e.toString()}')),
      );
    }
  }

  Future<void> _showDeleteDialog(PurchaseHistory order) async {
    await showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: const Text("Xóa đơn hàng"),
            content: Text("Bạn có chắc muốn xóa đơn hàng #${order.id}?"),
            actions: <Widget>[
              TextButton(
                child: const Text('Hủy'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _deleteOrder(order);
                },
              ),
            ],
          ),
    );
  }

  Future<void> _deleteOrder(PurchaseHistory order) async {
    try {
      await _purchaseHistoryDao.deletePurchaseHistory(order);
      await _loadOrders();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Đã xóa đơn hàng #${order.id}")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi xóa: ${e.toString()}')));
    }
  }
}
