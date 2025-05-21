import 'package:floor/floor.dart';

@Entity(tableName: 'customers')
class Customer {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String name;
  final String phone;
  final int points;

  Customer({
    required this.name,
    required this.id,
    required this.phone,
    this.points = 0,
  });
}
