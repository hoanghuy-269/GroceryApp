import 'package:floor/floor.dart';

@Entity(tableName: 'User')
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id; // Đặt là nullable

  String name;
  String email;
  String phone;
  String password;
  String role;

  User(this.id, this.name, this.email, this.phone, this.password, this.role);

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['id'] as int?,
      map['name'] as String,
      map['email'] as String,
      map['phone'] as String,
      map['password'] as String,
      map['role'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role, // Thêm vai trò vào đây
    };
  }
}
