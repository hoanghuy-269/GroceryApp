// lib/models/product.dart
import 'package:floor/floor.dart';
import '../database/date_time_converter.dart';

@Entity(tableName: 'Product')
class Product {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final double price;
  final int quantity;
  final String description;
  final String imgURL;
  final int loai;

  @TypeConverters([DateTimeConverter])
  final DateTime lastUpdated;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.description,
    required this.imgURL,
    required this.loai,
    required this.lastUpdated,
  });

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, imgURL: $imgURL, quantity: $quantity, description: $description}';
  }
}
