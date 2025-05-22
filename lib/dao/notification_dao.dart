import 'package:floor/floor.dart';
import 'package:grocery_app/models/notification.dart';

@dao
abstract class NotificationDao {
  // Lấy tất cả thông báo
  @Query('SELECT * FROM Notifications')
  Future<List<Notifications>> getAllNotifications();

  // Thêm thông báo mới
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertNotification(Notifications notification);

  // Xóa thông báo theo ID
  @Query('DELETE FROM Notifications WHERE id = :id')
  Future<void> deleteNotificationById(int id);

  // Xóa tất cả thông báo (nếu cần)
  @Query('DELETE FROM Notifications')
  Future<void> deleteAllNotifications();
}
