import 'package:floor/floor.dart';

@Entity(tableName: 'OrderItem')
class OrderItem {
  @primaryKey
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  OrderItem(this.id, this.orderId, this.productId, this.quantity);
}
