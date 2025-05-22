import 'package:floor/floor.dart';

@Entity(tableName: 'orders')
class Order {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final DateTime orderDate;
  final double totalAmount;

  Order({this.id, required this.orderDate, required this.totalAmount});
}
