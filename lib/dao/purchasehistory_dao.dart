import 'package:floor/floor.dart';
import 'package:grocery_app/models/purchaseHistory.dart';

@dao
abstract class PurchaseHistoryDao {
  @Query(
    'SELECT * FROM purchase_history WHERE email = :email ORDER BY date DESC',
  )
  Future<List<PurchaseHistory>> getHistoryByEmail(String email);

  @insert
  Future<void> insertHistory(PurchaseHistory history);

  @update
  Future<void> updatePurchaseHistory(PurchaseHistory purchaseHistory);

  @delete
  Future<void> deletePurchaseHistory(PurchaseHistory purchaseHistory);

  @Query('SELECT * FROM purchase_history')
  Future<List<PurchaseHistory>> getAllOrders();
}
