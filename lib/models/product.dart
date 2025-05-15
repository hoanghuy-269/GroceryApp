import 'package:floor/floor.dart';

@Entity(tableName: 'Product') 
class Product {
  @PrimaryKey()
  final int id;
  final String name;
  final double price;
  final String imgURL; 
  int quantity;
  final String description;
  final int loai;
   String status;
  

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imgURL, 
    required this.quantity,
    required this.description,
    required this.loai,
    required this.status
    
  });

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, imgURL: $imgURL, quantity: $quantity, description: $description , status , $status}';
  }
}

