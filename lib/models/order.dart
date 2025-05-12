import 'package:floor/floor.dart';

@Entity(tableName: 'Order')
class Order {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int date;

  Order({this.id, required this.date});

  factory Order.fromDateTime(DateTime dateTime) {
    return Order(date: dateTime.millisecondsSinceEpoch);
  }

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(date);
}
