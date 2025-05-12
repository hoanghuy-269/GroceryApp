import 'package:floor/floor.dart';

@Entity(tableName: 'User')
class User {
  @primaryKey
  final int id;
  final String name;
  final String email;

  User(this.id, this.name, this.email);
}
