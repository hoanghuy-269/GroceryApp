import 'dart:async';
import 'package:floor/floor.dart';
import 'package:grocery_app/dao/customer_dao.dart';
import 'package:grocery_app/models/purchaseHistory.dart';
import 'package:grocery_app/dao/order_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'date_time_converter.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/models/user.dart';
import 'package:grocery_app/models/order.dart';
import 'package:grocery_app/models/order_item.dart';
import 'package:grocery_app/models/wishlist.dart';
import 'package:grocery_app/dao/product_dao.dart';
import 'package:grocery_app/dao/user_dao.dart';
import 'package:grocery_app/dao/cart_dao.dart';
import 'package:grocery_app/dao/order_item_dao.dart';
import 'package:grocery_app/dao/wishlist_dao.dart';
import 'package:grocery_app/dao/purchasehistory_dao.dart';
import 'package:grocery_app/models/notification.dart';
import 'package:grocery_app/dao/notification_dao.dart';
import 'package:grocery_app/models/Customer.dart';
import 'package:grocery_app/models/cart.dart';
part 'app_database.g.dart';

@TypeConverters([DateTimeConverter])
@Database(
  version: 1,
  entities: [
    Product,
    User,
    Order,
    OrderItem,
    Wishlist,
    PurchaseHistory,
    Notifications,
    Customer,
    CartItem,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  ProductDao get productDao;
  UserDao get userDao;
  OrderDao get orderDao;
  OrderItemDao get orderItemDao;
  WishlistDao get wishlistDao;
  PurchaseHistoryDao get purchaseHistoryDao;
  NotificationDao get notificationDao;
  CustomerDao get customerDao;
  CartItemDao get cartItemDao;
}
