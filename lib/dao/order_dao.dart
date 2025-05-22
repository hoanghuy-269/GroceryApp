import 'package:floor/floor.dart';
import '../models/order.dart';

@dao
abstract class OrderDao {
  @Query('SELECT * FROM orders')
  Future<List<Order>> getAllOrders();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOrder(Order order);

  @delete
  Future<void> deleteOrder(Order order);

  @Query('SELECT * FROM Order WHERE id = :orderId')
  Future<Order?> getOrderByOrderID(int orderId);
}
