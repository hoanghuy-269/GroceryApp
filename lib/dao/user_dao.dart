import 'package:floor/floor.dart';
import '../models/user.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM User')
  Future<List<User>> getAllUsers();

  @Query('SELECT * FROM User WHERE id = :id')
  Future<User?> getUserById(int id);

  @Query('SELECT * FROM User WHERE email = :email LIMIT 1')
  Future<User?> getUserByEmail(String email);

  @Query('SELECT COUNT(*) FROM User WHERE email = :email')
  Future<int?> countUsersByEmail(String email);

  @Query('SELECT * FROM User WHERE name = :name')
  Future<User?> getUserByName(String name);

  @insert
  Future<void> insertUser(User user);

  @update
  Future<void> updateUser(User user);

  @delete
  Future<void> deleteUser(User user);
}
