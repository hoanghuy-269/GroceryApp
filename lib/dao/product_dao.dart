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
  @update
  Future<void> updateProduct(Product product);
  //
  @Query('DELETE FROM Product')
  Future<void> deleteAllProducts();

  @Query("SELECT * FROM Product Where loai = :categoryKey")
  Future<List<Product>> getProductByCategory(int categoryKey);

  @Query('SELECT * FROM Product ORDER BY lastUpdated DESC')
  Future<List<Product>> getAllProductsSortedByDate();
}
