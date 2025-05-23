import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận đăng xuất'),
            content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _logout();
                },
                child: const Text('Đăng xuất'),
              ),
            ],
          ),
    );
  }

  String _getLoaiText(int loai) {
    switch (loai) {
      case 1:
        return 'Đồ Ăn';
      case 2:
        return 'Nước Uống';
      case 3:
        return 'Mì - Cháo Ăn liền';
      case 4:
        return 'Gia vị';
      case 5:
        return 'Đồ dùng học tập';
      case 6:
        return 'Đồ dùng trong gia đình';
      default:
        return 'Khác';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý sản phẩm'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: _showLogoutDialog,
          ),
        ],
      ),

      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Tìm sản phẩm...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: onSearchChanged,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Phân loại',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedLoai,
                    onChanged: onLoaiChanged,
                    items: const [
                      DropdownMenuItem(value: null, child: Text('Tất cả')),
                      DropdownMenuItem(value: 1, child: Text('Đồ Ăn')),
                      DropdownMenuItem(value: 2, child: Text('Nước Uống')),
                      DropdownMenuItem(
                        value: 3,
                        child: Text('Mì - Cháo Ăn liền'),
                      ),
                      DropdownMenuItem(value: 4, child: Text('Gia vị')),
                      DropdownMenuItem(
                        value: 5,
                        child: Text('Đồ dùng học tập'),
                      ),
                      DropdownMenuItem(
                        value: 6,
                        child: Text('Đồ dùng trong gia đình'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child:
                displayedProducts.isEmpty
                    ? const Center(child: Text('Không tìm thấy sản phẩm'))
                    : ListView.builder(
                      itemCount: displayedProducts.length,
                      itemBuilder: (context, index) {
                        final p = displayedProducts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            title: Text(
                              p.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Giá: ${p.price}'),
                                Text('Số lượng: ${p.quantity}'),
                                Text('Loại: ${_getLoaiText(p.loai)}'),
                              ],
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
                                  (context) => const [
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
        child: const Icon(Icons.add),
        backgroundColor: Colors.green[700],
      ),
    );
  }
}
