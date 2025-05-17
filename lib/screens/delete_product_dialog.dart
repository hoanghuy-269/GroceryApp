import 'package:flutter/material.dart';
import '../models/product.dart';

void showDeleteProductDialog({
  required BuildContext context,
  required Product product,
  required VoidCallback onDelete,
}) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc muốn xóa sản phẩm "${product.name}" không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
                onDelete(); // Gọi hàm xóa
              },
              child: Text('Xóa'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
  );
}
