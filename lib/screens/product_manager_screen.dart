import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:grocery_app/dao/product_dao.dart';
import '../database/app_database.dart';
import '../models/product.dart';
import 'package:grocery_app/screens/login_screen.dart';

class ProductManagementScreen extends StatefulWidget {
  @override
  _ProductManagementScreenState createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  late ProductDao productDao;
  List<Product> _products = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      final database =
          await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      productDao = database.productDao;

      await _refreshProductList();
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Không thể khởi tạo cơ sở dữ liệu';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshProductList() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      final products = await productDao.getAllProducts();
      print('Danh sách sản phẩm hiện có:');
      for (var p in products) {
        print('ID: ${p.id}, Name: ${p.name}, Price: ${p.price}');
      }

      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Lỗi khi tải danh sách sản phẩm';
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
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
      body: _buildBodyContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Thêm sản phẩm mới',
      ),
    );
  }

  Widget _buildBodyContent() {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              _errorMessage,
              style: TextStyle(fontSize: 18, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _refreshProductList,
              child: Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải dữ liệu...'),
          ],
        ),
      );
    }

    if (_products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Chưa có sản phẩm nào",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              "Nhấn nút + để thêm sản phẩm mới",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showAddDialog(context),
              child: Text('Thêm sản phẩm mới'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshProductList,
      child: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 2,
            child: ListTile(
              leading: _buildProductImage(product.imgURL),
              title: Text(
                product.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    "Giá: ${NumberFormat.currency(locale: 'vi', symbol: '₫').format(product.price)}",
                    style: TextStyle(color: Colors.green),
                  ),
                  SizedBox(height: 2),
                  Text("Số lượng: ${product.quantity}"),
                  SizedBox(height: 2),
                  Text(
                    "Ngày: ${DateFormat('dd/MM/yyyy').format(product.lastUpdated)}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  if (product.description.isNotEmpty) ...[
                    SizedBox(height: 2),
                    Text(
                      "Mô tả: ${product.description}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showEditDialog(context, product),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteDialog(context, product),
                  ),
                ],
              ),
              onTap: () => _showProductDetails(context, product),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductImage(String imageUrl) {
    try {
      if (imageUrl.isEmpty) {
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.image, color: Colors.grey),
        );
      }
      return Image.asset(
        imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) => Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.broken_image, color: Colors.grey),
            ),
      );
    } catch (e) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.image, color: Colors.grey),
      );
    }
  }

  void _showProductDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Chi tiết sản phẩm"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (product.imgURL.isNotEmpty)
                  Center(child: _buildProductImage(product.imgURL)),
                SizedBox(height: 16),
                Text(
                  product.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Giá: ${NumberFormat.currency(locale: 'vi', symbol: '₫').format(product.price)}",
                  style: TextStyle(fontSize: 16, color: Colors.green),
                ),
                SizedBox(height: 8),
                Text("Số lượng: ${product.quantity}"),
                SizedBox(height: 8),
                Text(
                  "Ngày cập nhật: ${DateFormat('dd/MM/yyyy').format(product.lastUpdated)}",
                ),
                if (product.description.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Text("Mô tả:"),
                  SizedBox(height: 4),
                  Text(
                    product.description,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Đóng"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    _clearControllers();
    _selectedDate = DateTime.now();
    _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Thêm sản phẩm mới"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Tên sản phẩm*",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: "Giá*",
                    border: OutlineInputBorder(),
                    prefixText: '₫ ',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: "Số lượng*",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Mô tả",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    labelText: "Đường dẫn ảnh",
                    border: OutlineInputBorder(),
                    hintText: "assets/images/...",
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: "Ngày tạo/cập nhật",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Hủy", style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text("Thêm"),
              onPressed: () async {
                if (_validateInputs()) {
                  final newProduct = Product(
                    id: null,
                    name: _nameController.text,
                    price: double.parse(_priceController.text),
                    quantity: int.parse(_quantityController.text),
                    description: _descriptionController.text,
                    imgURL: _imageUrlController.text,
                    loai: 1,
                    lastUpdated: _selectedDate,
                    status: '',
                  );
                  await productDao.insertProduct(newProduct);
                  await _refreshProductList();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã thêm sản phẩm thành công'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Product product) {
    _nameController.text = product.name;
    _priceController.text = product.price.toString();
    _quantityController.text = product.quantity.toString();
    _descriptionController.text = product.description;
    _imageUrlController.text = product.imgURL;
    _selectedDate = product.lastUpdated;
    _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Sửa sản phẩm"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Tên sản phẩm*",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: "Giá*",
                    border: OutlineInputBorder(),
                    prefixText: '₫ ',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: "Số lượng*",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Mô tả",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    labelText: "Đường dẫn ảnh",
                    border: OutlineInputBorder(),
                    hintText: "assets/images/...",
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: "Ngày tạo/cập nhật",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Hủy", style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text("Lưu"),
              onPressed: () async {
                if (_validateInputs()) {
                  final updatedProduct = Product(
                    id: product.id,
                    name: _nameController.text,
                    price: double.parse(_priceController.text),
                    quantity: int.parse(_quantityController.text),
                    description: _descriptionController.text,
                    imgURL: _imageUrlController.text,
                    loai: product.loai,
                    lastUpdated: _selectedDate,
                    status: '',
                  );
                  await productDao.updateProduct(updatedProduct);
                  await _refreshProductList();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã cập nhật sản phẩm thành công'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  bool _validateInputs() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Vui lòng nhập tên sản phẩm"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (_priceController.text.isEmpty ||
        double.tryParse(_priceController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Giá sản phẩm không hợp lệ"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (_quantityController.text.isEmpty ||
        int.tryParse(_quantityController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Số lượng sản phẩm không hợp lệ"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  void _showDeleteDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Xóa sản phẩm"),
          content: Text("Bạn có chắc chắn muốn xóa '${product.name}'?"),
          actions: [
            TextButton(
              child: Text("Hủy"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Xóa", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await productDao.deleteProduct(product);
                await _refreshProductList();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã xóa sản phẩm thành công'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _clearControllers() {
    _nameController.clear();
    _priceController.clear();
    _quantityController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    _dateController.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}
