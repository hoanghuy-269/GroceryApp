import 'package:floor/floor.dart';

@Entity(tableName: 'Product') 
class Product {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final double price;
  final String imgURL; 
  late final int quantity;
  final String description;
  final int loai;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.imgURL, 
    required this.quantity,
    required this.description,
    required this.loai
  });

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, imgURL: $imgURL, quantity: $quantity, description: $description}';
  }
}

