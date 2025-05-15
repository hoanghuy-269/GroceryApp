// lib/models/product.dart
import 'package:floor/floor.dart';
import '../database/date_time_converter.dart';

@Entity(tableName: 'Product')
class Product {
  @PrimaryKey()
  final int? id;
  final String name;
  final double price;
  final String imgURL; 
  final int quantity;

  final String imgURL;
  int quantity;
  final String description;
  final int loai;
  String status;
  @TypeConverters([DateTimeConverter])
  final DateTime lastUpdated;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.description,
    required this.loai,
    required this.status,
    required this.imgURL,
    required this.lastUpdated,
  });

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, imgURL: $imgURL, quantity: $quantity, description: $description , status , $status}';
  }
  Product copyWith({int? quantity}) {
  return Product(
    id: id,
    name: name,
    price: price,
    imgURL: imgURL,
    quantity: quantity ?? this.quantity,
    description: description,
    loai: loai,
  );
}

}
