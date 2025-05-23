import 'package:flutter/material.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/models/Customer.dart';
import 'package:grocery_app/dao/customer_dao.dart';

class CustomerScreen extends StatefulWidget {
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  late CustomerDao _customerDao;
  List<Customer> customers = [];
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _customerDao = database.customerDao;
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    customers = await _customerDao.getAllCustomers();
    setState(() {});
  }

  Future<void> addCustomer() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) return;
    final customer = Customer(name: nameController.text, phone: phoneController.text, points: 0);
    await _customerDao.insertCustomer(customer);
    nameController.clear();
    phoneController.clear();
    _loadCustomers();
  }

  Future<void> deleteCustomer(int id) async {
    final customer = await _customerDao.getCustomerById(id);
    if (customer != null) {
      await _customerDao.deleteCustomer(customer);
      _loadCustomers();
    }
  }

  Future<void> showEditCustomerDialog(Customer customer) async {
    final editNameController = TextEditingController(text: customer.name);
    final editPhoneController = TextEditingController(text: customer.phone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sửa khách hàng"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: editNameController, decoration: InputDecoration(labelText: "Tên")),
            TextField(
              controller: editPhoneController,
              decoration: InputDecoration(labelText: "SĐT"),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Hủy")),
          TextButton(
            onPressed: () async {
              if (editNameController.text.isEmpty || editPhoneController.text.isEmpty) return;
              final updatedCustomer = Customer(
                id: customer.id,
                name: editNameController.text,
                phone: editPhoneController.text,
                points: customer.points,
              );
              await _customerDao.updateCustomer(updatedCustomer);
              _loadCustomers();
              Navigator.pop(context);
            },
            child: Text("Lưu"),
          ),
        ],
      ),
    );
  }

  Future<void> changePoints(int id, int delta) async {
    final customer = await _customerDao.getCustomerById(id);
    if (customer != null) {
      final updatedCustomer = Customer(
        id: customer.id,
        name: customer.name,
        phone: customer.phone,
        points: customer.points + delta,
      );
      await _customerDao.updateCustomer(updatedCustomer);
      _loadCustomers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Khách hàng")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Tên")),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "SĐT"),
              keyboardType: TextInputType.phone,
            ),
            ElevatedButton(onPressed: addCustomer, child: Text("Thêm")),
            Divider(),
            Text("Tổng: ${customers.length} khách hàng"),
            Expanded(
              child: ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final customer = customers[index];
                  return ListTile(
                    title: Text(customer.name ?? 'Không tên'),
                    subtitle: Text("SĐT: ${customer.phone ?? 'Không SĐT'}\nĐiểm: ${customer.points}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => changePoints(customer.id ?? 0, -1),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => changePoints(customer.id ?? 0, 1),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => showEditCustomerDialog(customer),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteCustomer(customer.id ?? 0),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}