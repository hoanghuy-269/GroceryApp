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
  List<Customer> filteredCustomers = [];
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final searchController = TextEditingController();

  bool isAdding = false;

  @override
  void initState() {
    super.initState();
    _initDatabase();
    searchController.addListener(_filterCustomers);
  }

  Future<void> _initDatabase() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _customerDao = database.customerDao;
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    customers = await _customerDao.getAllCustomers();
    _filterCustomers();
  }

  void _filterCustomers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredCustomers =
          customers.where((c) {
            final name = c.name?.toLowerCase() ?? '';
            final phone = c.phone?.toLowerCase() ?? '';
            return name.contains(query) || phone.contains(query);
          }).toList();
    });
  }

  Future<void> addCustomer() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) return;
    final customer = Customer(
      name: nameController.text,
      phone: phoneController.text,
      points: 0,
    );
    await _customerDao.insertCustomer(customer);
    nameController.clear();
    phoneController.clear();
    isAdding = false;
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
      builder:
          (context) => AlertDialog(
            title: Text("Sửa khách hàng"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: editNameController,
                  decoration: InputDecoration(labelText: "Tên"),
                ),
                TextField(
                  controller: editPhoneController,
                  decoration: InputDecoration(labelText: "SĐT"),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Hủy"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (editNameController.text.isEmpty ||
                      editPhoneController.text.isEmpty)
                    return;
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
      appBar: AppBar(title: Text("Quản lý khách hàng")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ô tìm kiếm
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Tìm kiếm theo tên hoặc SĐT",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 12),

              // Form thêm khách hàng
              if (isAdding)
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Thêm khách hàng mới",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Tên",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: "SĐT",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: addCustomer,
                            child: Text("Thêm khách hàng"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 10),

              Text(
                "Tổng: ${filteredCustomers.length} khách hàng",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Danh sách khách hàng
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredCustomers.length,
                itemBuilder: (context, index) {
                  final customer = filteredCustomers[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        customer.name ?? 'Không tên',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("SĐT: ${customer.phone ?? 'Không SĐT'}"),
                          Text("Điểm tích lũy: ${customer.points}"),
                        ],
                      ),
                      trailing: Wrap(
                        spacing: 0,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => changePoints(customer.id ?? 0, -1),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle, color: Colors.green),
                            onPressed: () => changePoints(customer.id ?? 0, 1),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blueAccent),
                            onPressed: () => showEditCustomerDialog(customer),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.grey),
                            onPressed: () => deleteCustomer(customer.id ?? 0),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isAdding = !isAdding;
          });
        },
        child: Icon(isAdding ? Icons.close : Icons.add),
        backgroundColor: Colors.green[700],
      ),
    );
  }
}
