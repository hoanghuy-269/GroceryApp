import 'package:floor/floor.dart';
import '../models/order.dart';

@dao
abstract class OrderDao {
  @Query('SELECT * FROM Order')
  Future<List<Order>> getAllOrders();

  @insert
  Future<void> insertOrder(Order order);

  @delete
  Future<void> deleteOrder(Order order);
}
