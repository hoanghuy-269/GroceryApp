import 'package:floor/floor.dart';

@Entity(tableName: 'cart_items')
class CartItem {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int productId;
  final String productName;
  final double price;
  final String imgURL;
  final int quantity;
  final double? discount;

  CartItem({
    this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.imgURL,
    this.quantity = 1,
    this.discount,
  });
}
