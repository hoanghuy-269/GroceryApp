import 'package:floor/floor.dart';
import '../models/order_item.dart';

@dao
abstract class OrderItemDao {
  @Query('SELECT * FROM OrderItem')
  Future<List<OrderItem>> getAllOrderItems();

  @insert
  Future<void> insertOrderItem(OrderItem orderItem);

  @delete
  Future<void> deleteOrderItem(OrderItem orderItem);
}
