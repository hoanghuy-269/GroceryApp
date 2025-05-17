import 'app_database.dart';

class DatabaseProvider {
  static AppDatabase? _database;
  static Future<AppDatabase> get database async {
    _database ??=
        await $FloorAppDatabase.databaseBuilder("app_database.db").build();
    return _database!;
  }
}
