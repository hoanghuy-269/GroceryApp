import 'package:floor/floor.dart';
import '../models/order_item.dart';

@dao
abstract class OrderItemDao {
  @Query('SELECT * FROM order_items')
  Future<List<OrderItem>> getAllOrderItems();

  @insert
  Future<void> insertOrderItem(OrderItem orderItem);

  @delete
  Future<void> deleteOrderItem(OrderItem orderItem);

  @Query('SELECT * FROM order_items WHERE orderId = :orderId')
  Future<List<OrderItem>> getOrderItemsByOrderId(int orderId);
}
