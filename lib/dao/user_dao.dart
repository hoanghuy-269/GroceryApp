import 'package:floor/floor.dart';
import '../models/user.dart';

@dao
abstract class UserDao {
  // Lấy tất cả người dùng
  @Query('SELECT * FROM User')
  Future<List<User>> getAllUsers();

  // Lấy người dùng theo ID
  @Query('SELECT * FROM User WHERE id = :id')
  Future<User?> getUserById(int id);

  // Lấy người dùng theo email
  @Query('SELECT * FROM User WHERE email = :email')
  Future<User?> getUserByEmail(String email);

  @Query('SELECT COUNT(*) FROM User WHERE email = :email')
  Future<int?> countUsersByEmail(String email);

  @insert
  Future<void> insertUser(User user);

  @update
  Future<void> updateUser(User user);

  @delete
  Future<void> deleteUser(User user);
}
