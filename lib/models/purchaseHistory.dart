import 'package:floor/floor.dart';

@Entity(tableName: 'purchase_history')
class PurchaseHistory {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String email;
  final String product;
  final int quantity;
  final double total;
  final String date;
  final String status;
  PurchaseHistory({
    this.id,
    required this.email,
    required this.product,
    required this.quantity,
    required this.total,
    required this.date,
    this.status = 'Chờ xác nhận',
  });
}
