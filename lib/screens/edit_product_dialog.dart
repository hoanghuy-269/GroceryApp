import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';

Future<void> showEditProductDialog({
  required BuildContext context,
  required Product product,
  required Function(Product) onSave,
}) async {
  final nameController = TextEditingController(text: product.name);
  final priceController = TextEditingController(text: product.price.toString());
  final quantityController = TextEditingController(
    text: product.quantity.toString(),
  );
  final descriptionController = TextEditingController(
    text: product.description,
  );
  final statusController = TextEditingController(text: product.status);

  int? selectedLoai = product.loai;
  File? pickedImageFile =
      product.imgURL.isNotEmpty ? File(product.imgURL) : null;
  String? updatedImagePath = product.imgURL;

  final loaiOptions = [
    {'id': 1, 'name': 'Đồ Ăn'},
    {'id': 2, 'name': 'Nước Uống'},
    {'id': 3, 'name': 'Mì - Cháo Ăn liền'},
    {'id': 4, 'name': 'Gia vị'},
    {'id': 5, 'name': 'Đồ dùng học tập'},
    {'id': 6, 'name': 'Đồ dùng trong gia đình'},
  ];

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
      updatedImagePath = savedFile.path;
    }
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Chỉnh sửa sản phẩm'),
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
                                    'Không có ảnh',
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
                        tooltip: 'Đổi ảnh',
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: inputDecoration('Tên sản phẩm'),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: priceController,
                    decoration: inputDecoration('Giá'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: quantityController,
                    decoration: inputDecoration('Số lượng'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    decoration: inputDecoration('Loại sản phẩm'),
                    value: selectedLoai,
                    items:
                        loaiOptions.map((option) {
                          return DropdownMenuItem<int>(
                            value: option['id'] as int,
                            child: Text(option['name'] as String),
                          );
                        }).toList(),
                    onChanged: (value) => setState(() => selectedLoai = value),
                  ),
                  SizedBox(height: 12),
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
                      selectedLoai == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Vui lòng nhập đầy đủ thông tin bắt buộc',
                        ),
                      ),
                    );
                    return;
                  }

                  final updatedProduct = Product(
                    id: product.id,
                    name: nameController.text,
                    price:
                        double.tryParse(priceController.text) ?? product.price,
                    imgURL: updatedImagePath ?? '',
                    quantity:
                        int.tryParse(quantityController.text) ??
                        product.quantity,
                    description: descriptionController.text,
                    loai: selectedLoai!,
                    status: statusController.text,
                    lastUpdated: DateTime.now(),
                  );

                  onSave(updatedProduct);
                  Navigator.pop(context);
                },
                child: Text('Lưu'),
              ),
            ],
          );
        },
      );
    },
  );
}
