import 'package:floor/floor.dart';

@Entity(tableName: 'Product') 
class Product {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final double price;
  final String imgURL; 
  final int quantity;
  final String description;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.imgURL, 
    required this.quantity,
    required this.description,
  });
}
