import 'package:flutter/material.dart';
import 'package:grocery_app/screens/botttom_navgation_srceen.dart';
//import 'package:grocery_app/screens/home.dart';
//import 'screens/account_screen.dart';
//import 'screens/favourite_screen.dart';
// import 'screens/order_screen.dart';
import 'package:grocery_app/database/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyBottom(),
    );
  }
}
