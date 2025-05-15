import 'package:flutter/material.dart';
import 'package:grocery_app/database/app_database.dart';
import 'package:grocery_app/screens/botttom_navgation_srceen.dart';
<<<<<<< HEAD
// import 'package:grocery_app/screens/home.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:grocery_app/screens/print.dart';
// import 'package:grocery_app/screens/account_screen.dart';
 import 'package:grocery_app/screens/login_screen.dart';
import 'package:grocery_app/screens/purchase_history_sreen.dart';


=======
import 'package:grocery_app/screens/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:grocery_app/screens/print.dart';
import 'package:grocery_app/screens/account_screen.dart';
import 'package:grocery_app/screens/login_screen.dart';
>>>>>>> d553437e755341a3d8eb5a5d070af5ba0bfa27e4

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo cơ sở dữ liệu Floor
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Home(),
    );
  }
}
