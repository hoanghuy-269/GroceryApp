import 'package:floor/floor.dart';
import '../models/wishlist.dart';

@dao
abstract class WishlistDao {
  @Query('SELECT * FROM Wishlist')
  Future<List<Wishlist>> getAllWishlists();

  @insert
  Future<void> insertWishlist(Wishlist wishlist);

  @delete
  Future<void> deleteWishlist(Wishlist wishlist);
}
