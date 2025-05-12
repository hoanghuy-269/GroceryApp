import 'package:floor/floor.dart';

@Entity(tableName: 'Product') // Sửa @entity thành @Entity
class Product {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;
  final double price;
  final String imgURL; // Sửa từ 'image' thành 'imgURL'
  final int quantity;
  final String description;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.imgURL, // Đảm bảo tham số này cũng là imgURL
    required this.quantity,
    required this.description,
  });
}
