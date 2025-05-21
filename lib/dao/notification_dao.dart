
import 'package:floor/floor.dart';
import 'package:grocery_app/models/notification.dart';

@dao
abstract class NotificationDao {
  @Query('SELECT * FROM Notifications ORDER BY timestamp DESC')
  Future<List<Notifications>> getAllNotifications();

  @insert
  Future<void> insertNotification(Notifications notification);

  @delete
  Future<void> deletenotification(Notifications notification);

  @Query('DELETE FROM Notifications WHERE endDate IS NOT NULL AND endDate < :currentTime')
  Future<void> deleteExpiredNotifications(String currentTime);
}