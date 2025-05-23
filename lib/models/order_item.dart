import 'package:floor/floor.dart';

@Entity(tableName: 'order_items')
class OrderItem {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int orderId;
  final int productId;
  final int quantity;
  final double price;
  final double? discount;

  OrderItem({
    this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    this.discount,
  });
}
