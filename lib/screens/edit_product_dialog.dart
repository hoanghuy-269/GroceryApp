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
  final loaiController = TextEditingController(text: product.loai.toString());
  final statusController = TextEditingController(text: product.status);

  File? pickedImageFile =
      product.imgURL.isNotEmpty ? File(product.imgURL) : null;
  String? updatedImagePath = product.imgURL;

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
                    loai: int.tryParse(loaiController.text) ?? product.loai,
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
