import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';

Future<void> showAddProductDialog({
  required BuildContext context,
  required Function(Product) onSave,
}) async {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final descriptionController = TextEditingController();
  final statusController = TextEditingController();
  final discountController = TextEditingController();

  File? pickedImageFile;
  String? savedImagePath;
  int? selectedLoaiId;

  final loaiOptions = [
    {'id': 1, 'name': 'Đồ Ăn'},
    {'id': 2, 'name': 'Nước Uống'},
    {'id': 3, 'name': 'Mì - Cháo Ăn liền'},
    {'id': 4, 'name': 'Gia vị'},
    {'id': 5, 'name': 'Đồ dùng học tập'},
    {'id': 6, 'name': 'Đồ dùng trong gia đình'},
  ];

  InputDecoration inputDecoration(String label) {
    return InputDecoration(labelText: label, border: OutlineInputBorder());
  }

  Future<void> pickAndSaveImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final tempFile = File(pickedFile.path);
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      final fileName = p.basename(pickedFile.path);
      final savedFile = await tempFile.copy('${imagesDir.path}/$fileName');
      pickedImageFile = savedFile;
      savedImagePath = savedFile.path;
    }
  }

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Thêm sản phẩm mới'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child:
                            pickedImageFile != null
                                ? Image.file(
                                  pickedImageFile!,
                                  fit: BoxFit.cover,
                                )
                                : Center(
                                  child: Text(
                                    'Chưa có ảnh',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          await pickAndSaveImage();
                          setState(() {});
                        },
                        tooltip: 'Chọn ảnh',
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: inputDecoration('Tên sản phẩm *'),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: priceController,
                    decoration: inputDecoration('Giá *'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: quantityController,
                    decoration: inputDecoration('Số lượng *'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: selectedLoaiId,
                    decoration: inputDecoration('Loại sản phẩm *'),
                    items:
                        loaiOptions.map((option) {
                          return DropdownMenuItem<int>(
                            value: option['id'] as int,
                            child: Text(option['name'] as String),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedLoaiId = value;
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: descriptionController,
                    decoration: inputDecoration('Mô tả'),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty ||
                      priceController.text.isEmpty ||
                      quantityController.text.isEmpty ||
                      selectedLoaiId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Vui lòng nhập đủ các trường bắt buộc!'),
                      ),
                    );
                    return;
                  }

                  final newProduct = Product(
                    id: null,
                    name: nameController.text.trim(),
                    price: double.tryParse(priceController.text) ?? 0.0,
                    imgURL: savedImagePath ?? '',
                    quantity: int.tryParse(quantityController.text) ?? 0,
                    description: descriptionController.text.trim(),
                    loai: selectedLoaiId!,
                    status: statusController.text.trim(),
                    lastUpdated: DateTime.now(),
                  );

                  onSave(newProduct);
                  Navigator.pop(context);
                },
                child: Text('Thêm'),
              ),
            ],
          );
        },
      );
    },
  );
}
