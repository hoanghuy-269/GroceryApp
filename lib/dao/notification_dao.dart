import 'package:floor/floor.dart';
import 'package:grocery_app/models/notification.dart';

@dao
abstract class NotificationDao {
  @Query('SELECT * FROM Notifications')
  Future<List<Notifications>> getAllNotifications();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertNotification(Notifications notification);

  @Query('DELETE FROM Notifications WHERE id = :id')
  Future<void> deleteNotificationById(int id);

  @Query('DELETE FROM Notifications')
  Future<void> deleteAllNotifications();
}
