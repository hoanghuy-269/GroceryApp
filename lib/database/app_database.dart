import 'dart:async';
import 'package:floor/floor.dart';
import 'package:grocery_app/models/PurchaseHistory.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'date_time_converter.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/models/user.dart';
import 'package:grocery_app/models/order.dart';
import 'package:grocery_app/models/order_item.dart';
import 'package:grocery_app/models/wishlist.dart';

import 'package:grocery_app/dao/product_dao.dart';
import 'package:grocery_app/dao/user_dao.dart';
import 'package:grocery_app/dao/order_dao.dart';
import 'package:grocery_app/dao/order_item_dao.dart';
import 'package:grocery_app/dao/wishlist_dao.dart';
import 'package:grocery_app/dao/purchasehistory_dao.dart';


part 'app_database.g.dart';

<<<<<<< HEAD
@Database(version: 1, entities: [Product, User, Order, OrderItem, Wishlist,PurchaseHistory])
=======
@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Product, User, Order, OrderItem, Wishlist])
>>>>>>> 1ca1fd05f6feaf06c44266b5a91fa54fd747c375
abstract class AppDatabase extends FloorDatabase {
  ProductDao get productDao;
  UserDao get userDao;
  OrderDao get orderDao;
  OrderItemDao get orderItemDao;
  WishlistDao get wishlistDao;
  PurchaseHistoryDao get purchaseHistoryDao;
}
