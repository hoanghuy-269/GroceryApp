import 'package:floor/floor.dart';
import 'package:grocery_app/models/product.dart';

@dao
abstract class ProductDao {
  @Query('SELECT * FROM Product')
  Future<List<Product>> getAllProducts();

  @insert
  Future<void> insertProduct(Product product);

  @delete
  Future<void> deleteProduct(Product product);
  
  @Query('DELETE FROM Product')
  Future<void> deleteAllProducts();

  @Query("SELECT * FROM Product Where loai = :categoryKey")
  Future<List<Product>> getProductByCategory(int categoryKey);

 @Query('SELECT * FROM Product Where id = :id')
  Future<Product?> findProductByID(int id);

  @update
  Future<void> updateProduct(Product product); 

  @Query('SELECT * FROM Product ORDER BY lastUpdated DESC')
  Future<List<Product>> getAllProductsSortedByDate();

@Query('UPDATE product SET discount = :discount WHERE loai = :loai')
Future<void> updateDiscountForCategory(int loai, double discount);

@Query('UPDATE product SET discount = NULL WHERE loai = :loai')
Future<void> clearDiscountForCategory(int loai);

}
