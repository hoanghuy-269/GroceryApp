import 'package:floor/floor.dart';

@Entity(tableName: 'Notifications')
class Notifications {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String title;
  final String message;
  final String timestamp; 
  final String type;
  final double? discount;
  final String? endDate;
  final int? key;

  Notifications({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.discount,
    this.endDate,
    this.key,
  });
}