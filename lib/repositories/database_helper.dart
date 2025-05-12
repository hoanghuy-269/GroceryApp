// import 'package:grocery_app/models/product.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   static Database? _database;

//   factory DatabaseHelper() {
//     return _instance;
//   }

//   DatabaseHelper._internal();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'grocery_store.db');
//     return await openDatabase(
//       path,
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE users (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             name TEXT,
//             email TEXT UNIQUE,
//             password TEXT
//           )
//         ''');

//         await db.execute('''
//           CREATE TABLE products (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             name TEXT,
//             price REAL,
//             image TEXT,
//             quantity INTEGER,
//             description TEXT
//           )
//         ''');

//         await db.execute('''
//           CREATE TABLE orders (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             userId INTEGER,
//             orderDate TEXT,
//             total REAL,
//             FOREIGN KEY(userId) REFERENCES users(id)
//           )
//         ''');

//         await db.execute('''
//           CREATE TABLE order_items (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             orderId INTEGER,
//             productId INTEGER,
//             quantity INTEGER,
//             price REAL,
//             FOREIGN KEY(orderId) REFERENCES orders(id),
//             FOREIGN KEY(productId) REFERENCES products(id)
//           )
//         ''');
//       },
//       version: 1,
//     );
//   }

//   // Phương thức chung để chèn dữ liệu vào các bảng
//   Future<void> insertData(String table, Map<String, dynamic> data) async {
//     final db = await database;
//     await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   // Phương thức thêm người dùng
//   Future<void> insertUser(Map<String, dynamic> user) async {
//     await insertData('users', user);
//   }

//   // Phương thức thêm sản phẩm
//   Future<void> insertProduct(Product product) async {
//     await insertData('products', product.toMap());
//   }

//   // Phương thức thêm đơn hàng
//   Future<void> insertOrder(Map<String, dynamic> order) async {
//     await insertData('orders', order);
//   }

//   // Phương thức thêm mục trong đơn hàng
//   Future<void> insertOrderItem(Map<String, dynamic> orderItem) async {
//     await insertData('order_items', orderItem);
//   }

//   // Lấy danh sách người dùng
//   Future<List<Map<String, dynamic>>> getUsers() async {
//     final db = await database;
//     return await db.query('users');
//   }

//   // Lấy danh sách sản phẩm
//   Future<List<Product>> getProducts() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('products');

//     return List.generate(maps.length, (i) {
//       return Product.fromMap(maps[i]);
//     });
//   }

//   // Lấy danh sách đơn hàng
//   Future<List<Map<String, dynamic>>> getOrders() async {
//     final db = await database;
//     return await db.query('orders');
//   }

//   // Lấy các mục trong đơn hàng theo điều kiện
//   Future<List<Map<String, dynamic>>> getOrderItems({
//     int? orderId,
//     int? productId,
//   }) async {
//     final db = await database;
//     String whereClause = '';
//     List<dynamic> whereArgs = [];

//     if (orderId != null) {
//       whereClause = 'orderId = ?';
//       whereArgs.add(orderId);
//     }

//     if (productId != null) {
//       whereClause =
//           whereClause.isEmpty
//               ? 'productId = ?'
//               : '$whereClause AND productId = ?';
//       whereArgs.add(productId);
//     }

//     return await db.query(
//       'order_items',
//       where: whereClause.isEmpty ? null : whereClause,
//       whereArgs: whereArgs.isEmpty ? null : whereArgs,
//     );
//   }

//   // Xóa sản phẩm theo ID
//   Future<void> deleteProduct(int productId) async {
//     final db = await database;
//     await db.delete('products', where: 'id = ?', whereArgs: [productId]);
//   }
// }
