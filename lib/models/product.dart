// lib/models/product.dart
import 'package:floor/floor.dart';
import '../database/date_time_converter.dart';

@Entity(tableName: 'Product')
class Product {
  @PrimaryKey()
  final int id;
  final String name;
  final double price;
<<<<<<< HEAD
  final String imgURL; 
  int quantity;
=======
  final int quantity;
>>>>>>> 1ca1fd05f6feaf06c44266b5a91fa54fd747c375
  final String description;
  final String imgURL;
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
<<<<<<< HEAD
    required this.loai,
    required this.status
    
=======
    required this.imgURL,
    required this.loai,
    required this.lastUpdated,
>>>>>>> 1ca1fd05f6feaf06c44266b5a91fa54fd747c375
  });

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, imgURL: $imgURL, quantity: $quantity, description: $description , status , $status}';
  }
}
