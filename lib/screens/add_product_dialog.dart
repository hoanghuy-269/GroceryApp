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
  final loaiController = TextEditingController();
  final statusController = TextEditingController();

  File? pickedImageFile;
  String? savedImagePath;

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

      // Tạo tên file mới để tránh trùng
      final fileName = p.basename(pickedFile.path);
      final savedFile = await tempFile.copy('${imagesDir.path}/$fileName');
      print('Image saved to: ${savedFile.path}');

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
                    decoration: InputDecoration(labelText: 'Tên sản phẩm'),
                  ),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Giá'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: quantityController,
                    decoration: InputDecoration(labelText: 'Số lượng'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Mô tả'),
                    maxLines: 3,
                  ),
                  TextField(
                    controller: loaiController,
                    decoration: InputDecoration(
                      labelText: 'Loại (ID số nguyên)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: statusController,
                    decoration: InputDecoration(labelText: 'Trạng thái'),
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
                  final newProduct = Product(
                    id: null,
                    name: nameController.text,
                    price: double.tryParse(priceController.text) ?? 0.0,
                    imgURL: savedImagePath ?? '',
                    quantity: int.tryParse(quantityController.text) ?? 0,
                    description: descriptionController.text,
                    loai: int.tryParse(loaiController.text) ?? 0,
                    status: statusController.text,
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
