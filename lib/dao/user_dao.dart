import 'package:floor/floor.dart';
import '../models/user.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM User')
  Future<List<User>> getAllUsers();

  @insert
  Future<void> insertUser(User user);

  @delete
  Future<void> deleteUser(User user);
}
