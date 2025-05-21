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

  // Lấy người dùng theo email, chỉ lấy 1 dòng
  @Query('SELECT * FROM User WHERE email = :email LIMIT 1')
  Future<User?> getUserByEmail(String email);

  // Đếm số lượng người dùng với email cụ thể
  @Query('SELECT COUNT(*) FROM User WHERE email = :email')
  Future<int?> countUsersByEmail(String email);

  @Query('SELECT * FROM User WHERE name = :name')
  Future<User?> getUserByName(String name);

  // Thêm người dùng
  @insert
  Future<void> insertUser(User user);

  // Cập nhật thông tin người dùng
  @update
  Future<void> updateUser(User user);

  // Xóa người dùng
  @delete
  Future<void> deleteUser(User user);
}
