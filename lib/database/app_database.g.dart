// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ProductDao? _productDaoInstance;

  UserDao? _userDaoInstance;

  OrderDao? _orderDaoInstance;

  OrderItemDao? _orderItemDaoInstance;

  WishlistDao? _wishlistDaoInstance;

  PurchaseHistoryDao? _purchaseHistoryDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Product` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `price` REAL NOT NULL, `imgURL` TEXT NOT NULL, `quantity` INTEGER NOT NULL, `description` TEXT NOT NULL, `loai` INTEGER NOT NULL, `status` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `email` TEXT NOT NULL, `phone` TEXT NOT NULL, `password` TEXT NOT NULL, `role` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Order` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `OrderItem` (`id` INTEGER NOT NULL, `orderId` INTEGER NOT NULL, `productId` INTEGER NOT NULL, `quantity` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Wishlist` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userId` INTEGER NOT NULL, `productId` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `purchase_history` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `email` TEXT NOT NULL, `product` TEXT NOT NULL, `quantity` INTEGER NOT NULL, `total` REAL NOT NULL, `date` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ProductDao get productDao {
    return _productDaoInstance ??= _$ProductDao(database, changeListener);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  OrderDao get orderDao {
    return _orderDaoInstance ??= _$OrderDao(database, changeListener);
  }

  @override
  OrderItemDao get orderItemDao {
    return _orderItemDaoInstance ??= _$OrderItemDao(database, changeListener);
  }

  @override
  WishlistDao get wishlistDao {
    return _wishlistDaoInstance ??= _$WishlistDao(database, changeListener);
  }

  @override
  PurchaseHistoryDao get purchaseHistoryDao { return _purchaseHistoryDaoInstance ??=_$PurchaseHistoryDao(database, changeListener);
  }
}

class _$ProductDao extends ProductDao {
  _$ProductDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productInsertionAdapter = InsertionAdapter(
            database,
            'Product',
            (Product item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'price': item.price,
                  'imgURL': item.imgURL,
                  'quantity': item.quantity,
                  'description': item.description,
                  'loai': item.loai,
                  'status': item.status
                }),
        _productUpdateAdapter = UpdateAdapter(
            database,
            'Product',
            ['id'],
            (Product item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'price': item.price,
                  'imgURL': item.imgURL,
                  'quantity': item.quantity,
                  'description': item.description,
                  'loai': item.loai,
                  'status': item.status
                }),
        _productDeletionAdapter = DeletionAdapter(
            database,
            'Product',
            ['id'],
            (Product item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'price': item.price,
                  'imgURL': item.imgURL,
                  'quantity': item.quantity,
                  'description': item.description,
                  'loai': item.loai,
                  'status': item.status
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Product> _productInsertionAdapter;

  final UpdateAdapter<Product> _productUpdateAdapter;

  final DeletionAdapter<Product> _productDeletionAdapter;

  @override
  Future<List<Product>> getAllProducts() async {
    return _queryAdapter.queryList('SELECT * FROM Product',
        mapper: (Map<String, Object?> row) => Product(
            id: row['id'] as int,
            name: row['name'] as String,
            price: row['price'] as double,
            imgURL: row['imgURL'] as String,
            quantity: row['quantity'] as int,
            description: row['description'] as String,
            loai: row['loai'] as int,
            status: row['status'] as String));
  }

  @override
  Future<void> deleteAllProducts() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Product');
  }

  @override
  Future<List<Product>> getProductByCategory(int categoryKey) async {
    return _queryAdapter.queryList('SELECT * FROM Product Where loai = ?1',
        mapper: (Map<String, Object?> row) => Product(
            id: row['id'] as int,
            name: row['name'] as String,
            price: row['price'] as double,
            imgURL: row['imgURL'] as String,
            quantity: row['quantity'] as int,
            description: row['description'] as String,
            loai: row['loai'] as int,
            status: row['status'] as String),
        arguments: [categoryKey]);
  }

  @override
  Future<Product?> findProductByID(int id) async {
    return _queryAdapter.query('SELECT * FROM Product Where id = ?1',
        mapper: (Map<String, Object?> row) => Product(
            id: row['id'] as int,
            name: row['name'] as String,
            price: row['price'] as double,
            imgURL: row['imgURL'] as String,
            quantity: row['quantity'] as int,
            description: row['description'] as String,
            loai: row['loai'] as int,
            status: row['status'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertProduct(Product product) async {
    await _productInsertionAdapter.insert(product, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateProduct(Product product) async {
    await _productUpdateAdapter.update(product, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteProduct(Product product) async {
    await _productDeletionAdapter.delete(product);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'phone': item.phone,
                  'password': item.password,
                  'role': item.role
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'phone': item.phone,
                  'password': item.password,
                  'role': item.role
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'phone': item.phone,
                  'password': item.password,
                  'role': item.role
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<List<User>> getAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM User',
        mapper: (Map<String, Object?> row) => User(
            row['id'] as int?,
            row['name'] as String,
            row['email'] as String,
            row['phone'] as String,
            row['password'] as String,
            row['role'] as String));
  }

  @override
  Future<User?> getUserById(int id) async {
    return _queryAdapter.query('SELECT * FROM User WHERE id = ?1',
        mapper: (Map<String, Object?> row) => User(
            row['id'] as int?,
            row['name'] as String,
            row['email'] as String,
            row['phone'] as String,
            row['password'] as String,
            row['role'] as String),
        arguments: [id]);
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    return _queryAdapter.query('SELECT * FROM User WHERE email = ?1',
        mapper: (Map<String, Object?> row) => User(
            row['id'] as int?,
            row['name'] as String,
            row['email'] as String,
            row['phone'] as String,
            row['password'] as String,
            row['role'] as String),
        arguments: [email]);
  }

  @override
  Future<int?> countUsersByEmail(String email) async {
    return _queryAdapter.query('SELECT COUNT(*) FROM User WHERE email = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [email]);
  }

  @override
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDeletionAdapter.delete(user);
  }
}

class _$OrderDao extends OrderDao {
  _$OrderDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _orderInsertionAdapter = InsertionAdapter(
            database,
            'Order',
            (Order item) =>
                <String, Object?>{'id': item.id, 'date': item.date}),
        _orderDeletionAdapter = DeletionAdapter(
            database,
            'Order',
            ['id'],
            (Order item) =>
                <String, Object?>{'id': item.id, 'date': item.date});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Order> _orderInsertionAdapter;

  final DeletionAdapter<Order> _orderDeletionAdapter;

  @override
  Future<List<Order>> getAllOrders() async {
    return _queryAdapter.queryList('SELECT * FROM Order',
        mapper: (Map<String, Object?> row) =>
            Order(id: row['id'] as int?, date: row['date'] as int));
  }

  @override
  Future<void> insertOrder(Order order) async {
    await _orderInsertionAdapter.insert(order, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteOrder(Order order) async {
    await _orderDeletionAdapter.delete(order);
  }
}

class _$OrderItemDao extends OrderItemDao {
  _$OrderItemDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _orderItemInsertionAdapter = InsertionAdapter(
            database,
            'OrderItem',
            (OrderItem item) => <String, Object?>{
                  'id': item.id,
                  'orderId': item.orderId,
                  'productId': item.productId,
                  'quantity': item.quantity
                }),
        _orderItemDeletionAdapter = DeletionAdapter(
            database,
            'OrderItem',
            ['id'],
            (OrderItem item) => <String, Object?>{
                  'id': item.id,
                  'orderId': item.orderId,
                  'productId': item.productId,
                  'quantity': item.quantity
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<OrderItem> _orderItemInsertionAdapter;

  final DeletionAdapter<OrderItem> _orderItemDeletionAdapter;

  @override
  Future<List<OrderItem>> getAllOrderItems() async {
    return _queryAdapter.queryList('SELECT * FROM OrderItem',
        mapper: (Map<String, Object?> row) => OrderItem(
            row['id'] as int,
            row['orderId'] as int,
            row['productId'] as int,
            row['quantity'] as int));
  }

  @override
  Future<void> insertOrderItem(OrderItem orderItem) async {
    await _orderItemInsertionAdapter.insert(
        orderItem, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteOrderItem(OrderItem orderItem) async {
    await _orderItemDeletionAdapter.delete(orderItem);
  }
}

class _$WishlistDao extends WishlistDao {
  _$WishlistDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _wishlistInsertionAdapter = InsertionAdapter(
            database,
            'Wishlist',
            (Wishlist item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'productId': item.productId
                }),
        _wishlistDeletionAdapter = DeletionAdapter(
            database,
            'Wishlist',
            ['id'],
            (Wishlist item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'productId': item.productId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Wishlist> _wishlistInsertionAdapter;

  final DeletionAdapter<Wishlist> _wishlistDeletionAdapter;

  @override
  Future<List<Wishlist>> getAllWishlists() async {
    return _queryAdapter.queryList('SELECT * FROM Wishlist',
        mapper: (Map<String, Object?> row) => Wishlist(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            productId: row['productId'] as int));
  }

  @override
  Future<void> insertWishlist(Wishlist wishlist) async {
    await _wishlistInsertionAdapter.insert(wishlist, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteWishlist(Wishlist wishlist) async {
    await _wishlistDeletionAdapter.delete(wishlist);
  }
}

class _$PurchaseHistoryDao extends PurchaseHistoryDao {
  _$PurchaseHistoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _purchaseHistoryInsertionAdapter = InsertionAdapter(
            database,
            'purchase_history',
            (PurchaseHistory item) => <String, Object?>{
                  'id': item.id,
                  'email': item.email,
                  'product': item.product,
                  'quantity': item.quantity,
                  'total': item.total,
                  'date': item.date
                }),
        _purchaseHistoryUpdateAdapter = UpdateAdapter(
            database,
            'purchase_history',
            ['id'],
            (PurchaseHistory item) => <String, Object?>{
                  'id': item.id,
                  'email': item.email,
                  'product': item.product,
                  'quantity': item.quantity,
                  'total': item.total,
                  'date': item.date
                }),
        _purchaseHistoryDeletionAdapter = DeletionAdapter(
            database,
            'purchase_history',
            ['id'],
            (PurchaseHistory item) => <String, Object?>{
                  'id': item.id,
                  'email': item.email,
                  'product': item.product,
                  'quantity': item.quantity,
                  'total': item.total,
                  'date': item.date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PurchaseHistory> _purchaseHistoryInsertionAdapter;

  final UpdateAdapter<PurchaseHistory> _purchaseHistoryUpdateAdapter;

  final DeletionAdapter<PurchaseHistory> _purchaseHistoryDeletionAdapter;

  @override
  Future<List<PurchaseHistory>> getHistoryByEmail(String email) async {
    return _queryAdapter.queryList(
        'SELECT * FROM purchase_history WHERE email = ?1 ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => PurchaseHistory(
            id: row['id'] as int?,
            email: row['email'] as String,
            product: row['product'] as String,
            quantity: row['quantity'] as int,
            total: row['total'] as double,
            date: row['date'] as String),
        arguments: [email]);
  }

  @override
  Future<void> insertHistory(PurchaseHistory history) async {
    await _purchaseHistoryInsertionAdapter.insert(
        history, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePurchaseHistory(PurchaseHistory purchaseHistory) async {
    await _purchaseHistoryUpdateAdapter.update(
        purchaseHistory, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePurchaseHistory(PurchaseHistory purchaseHistory) async {
    await _purchaseHistoryDeletionAdapter.delete(purchaseHistory);
  }
}
