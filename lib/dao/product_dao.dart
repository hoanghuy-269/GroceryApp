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

<<<<<<< HEAD
@Query('SELECT * FROM Product Where id = :id')
  Future<Product?> findProductByID(int id);

  @update
  Future<void> updateProduct(Product product); 

=======
  @Query('SELECT * FROM Product ORDER BY lastUpdated DESC')
  Future<List<Product>> getAllProductsSortedByDate();
>>>>>>> 1ca1fd05f6feaf06c44266b5a91fa54fd747c375
}
