import 'package:flutter/material.dart';
import 'package:grocery_app/models/Customer.dart';

class CustomerScreen extends StatefulWidget {
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Customer> customers = [];
  int nextId = 1;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void addCustomer() {
    setState(() {
      customers.add(Customer(
        id: nextId++,
        name: nameController.text,
        phone: phoneController.text,
      ));
      nameController.clear();
      phoneController.clear();
    });
  }

  void deleteCustomer(int id) {
    setState(() {
      customers.removeWhere((c) => c.id == id);
    });
  }

  void updateCustomer(int id, String newName, String newPhone) {
    setState(() {
      final index = customers.indexWhere((c) => c.id == id);
      if (index != -1) {
        final old = customers[index];
        customers[index] = Customer(
          id: old.id,
          name: newName,
          phone: newPhone,
          points: old.points,
        );
      }
    });
  }

  void changePoints(int id, int delta) {
    setState(() {
      final index = customers.indexWhere((c) => c.id == id);
      if (index != -1) {
        final old = customers[index];
        customers[index] = Customer(
          id: old.id,
          name: old.name,
          phone: old.phone,
          points: old.points + delta,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quản lý khách hàng")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Tên khách hàng"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Số điện thoại"),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: addCustomer, child: Text("Thêm")),
                ElevatedButton(
                  onPressed: () {
                    if (customers.isNotEmpty) {
                      deleteCustomer(customers.last.id);
                    }
                  },
                  child: Text("Xóa"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (customers.isNotEmpty) {
                      updateCustomer(
                        customers.last.id,
                        "Tên mới",
                        "0987654321",
                      );
                    }
                  },
                  child: Text("Sửa"),
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final customer = customers[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(customer.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("SDT: ${customer.phone}"),
                          Row(
                            children: [
                              Text("Điểm: ${customer.points}"),
                              SizedBox(width: 10),
                              IconButton(
                                icon: Icon(Icons.remove, color: Colors.red),
                                onPressed: () => changePoints(customer.id, -1),
                              ),
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.green),
                                onPressed: () => changePoints(customer.id, 1),
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
          ],
        ),
      ),
    );
  }
}
