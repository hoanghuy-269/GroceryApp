import 'package:floor/floor.dart';

@Entity(tableName: 'Notifications')
class Notifications {
  @PrimaryKey()
  final int id; // ID của thông báo
  final String title; // Tiêu đề thông báo
  final String message; // Nội dung thông báo
  final String timestamp; // Ngày thông báo

  Notifications({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
  });

  // Phương thức copyWith để dễ dàng cập nhật
  Notifications copyWith({
    int? id,
    String? title,
    String? message,
    String? timestamp,
  }) {
    return Notifications(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
