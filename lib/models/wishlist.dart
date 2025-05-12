import 'package:floor/floor.dart';

@Entity(tableName: 'Wishlist')
class Wishlist {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int userId; // ID của người dùng
  final int productId; // ID của sản phẩm

  Wishlist({this.id, required this.userId, required this.productId});
}
