import 'package:floor/floor.dart';
import '../models/cart.dart';

@dao
abstract class CartItemDao {
  @Query('SELECT * FROM cart_items')
  Future<List<CartItem>> getAllCartItems();

  @Query('SELECT * FROM cart_items WHERE productId = :productId')
  Future<CartItem?> findCartItemByProductId(int productId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCartItem(CartItem cartItem);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateCartItem(CartItem cartItem);

  @delete
  Future<void> deleteCartItem(CartItem cartItem);

  @Query('DELETE FROM cart_items')
  Future<void> deleteAllCartItems();
}
