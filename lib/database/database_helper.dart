import 'dart:io';
import 'package:flutter/services.dart';
import 'package:grocery_app/models/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  // Signleton Pattern tạo đối DatabaseHelper._ineernal duy nhất trong vòng đời
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // dùng về cái bản _instrance
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // Hàm này giúp mình truy cập database, và đảm bảo chỉ khởi tạo 1 lần duy nhất
  Future<Database> get database async {
    // Nếu đã khởi tạo thì trả về nó 
    if (_database != null) {
      return _database!;
    }
    // Nếu chưa có thì khởi tạo database
    _database = await _initDatabase();

    // Trả về database đã khởi tạo
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbName = 'grocery_store.db';
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = join(documentsDirectory.path, dbName);

    // Nếu file DB chưa tồn tại, copy từ assets
    if (!await File(dbPath).exists()) {
      final data = await rootBundle.load('assets/$dbName');
      final bytes = data.buffer.asUint8List();
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(dbPath);
  }

  // ---------- USER ----------
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // ---------- PRODUCT ----------
  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<void> deleteAllProducts() async {
    final db = await database;
    await db.delete('products');
  }

  // ---------- ORDER ----------
  Future<void> insertOrder(Map<String, dynamic> order) async {
    final db = await database;
    await db.insert(
      'orders',
      order,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await database;
    return await db.query('orders');
  }

  // ---------- ORDER ITEM ----------
  Future<void> insertOrderItem(Map<String, dynamic> item) async {
    final db = await database;
    await db.insert(
      'order_items',
      item,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getOrderItems(int orderId) async {
    final db = await database;
    return await db.query(
      'order_items',
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
  }
}
