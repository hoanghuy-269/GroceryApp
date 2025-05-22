import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Thêm import
import '../database/app_database.dart';
import '../models/product.dart';
import 'add_product_dialog.dart';
import 'edit_product_dialog.dart';
import 'delete_product_dialog.dart';
import 'package:grocery_app/dao/product_dao.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:grocery_app/database/database_provider.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({Key? key}) : super(key: key);

  @override
  State<ProductManagementScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductManagementScreen> {
  late AppDatabase database;
  late ProductDao productDao;
  List<Product> allProducts = [];
  List<Product> displayedProducts = [];
  String searchQuery = '';
  int? selectedLoai;

  @override
  void initState() {
    super.initState();
    initDb();
  }

  Future<void> initDb() async {
    database = await DatabaseProvider.database;
    productDao = database.productDao;
    await refreshList();
  }

  Future<void> refreshList() async {
    allProducts = await productDao.getAllProducts();
    applyFilters();
  }

  void applyFilters() {
    setState(() {
      displayedProducts =
          allProducts.where((product) {
            final matchesSearch = product.name.toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
            final matchesLoai =
                selectedLoai == null || product.loai == selectedLoai;
            return matchesSearch && matchesLoai;
          }).toList();
    });
  }

  void onSearchChanged(String query) {
    searchQuery = query;
    applyFilters();
  }

  void onLoaiChanged(int? loai) {
    selectedLoai = loai;
    applyFilters();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý sản phẩm'),
        actions: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Xác nhận đăng xuất'),
                    content: const Text(
                      'Bạn có chắc chắn muốn đăng xuất không?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _logout();
                        },
                        child: const Text('Đăng xuất'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Log Out'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm sản phẩm...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: onSearchChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Phân loại',
                border: OutlineInputBorder(),
              ),
              value: selectedLoai,
              items: [
                DropdownMenuItem(value: null, child: Text('Tất cả')),
                DropdownMenuItem(value: 1, child: Text('Đồ Ăn')),
                DropdownMenuItem(value: 2, child: Text('Nước Uống')),
                DropdownMenuItem(value: 3, child: Text('Mì - Cháo Ăn liền')),
                DropdownMenuItem(value: 4, child: Text('Gia vị')),
                DropdownMenuItem(value: 5, child: Text('Đồ dùng học tập')),
                DropdownMenuItem(
                  value: 6,
                  child: Text('Đồ dùng trong gia đình'),
                ),
              ],
              onChanged: onLoaiChanged,
            ),
          ),
          Expanded(
            child:
                displayedProducts.isEmpty
                    ? Center(child: Text('Không tìm thấy sản phẩm'))
                    : ListView.builder(
                      itemCount: displayedProducts.length,
                      itemBuilder: (context, index) {
                        final p = displayedProducts[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: ListTile(
                            title: Text(p.name),
                            subtitle: Text(
                              'Giá: ${p.price} - SL: ${p.quantity} - Loại: ${p.loai}',
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  showEditProductDialog(
                                    context: context,
                                    product: p,
                                    onSave: (updatedProduct) async {
                                      await productDao.updateProduct(
                                        updatedProduct,
                                      );
                                      await refreshList();
                                    },
                                  );
                                } else if (value == 'delete') {
                                  showDeleteProductDialog(
                                    context: context,
                                    product: p,
                                    onDelete: () async {
                                      await productDao.deleteProduct(p);
                                      await refreshList();
                                    },
                                  );
                                }
                              },
                              itemBuilder:
                                  (context) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Sửa'),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Xóa'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddProductDialog(
            context: context,
            onSave: (newProduct) async {
              await productDao.insertProduct(newProduct);
              await refreshList();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
