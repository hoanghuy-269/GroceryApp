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

  @Query("SELECT * FROM Product WHERE loai = :categoryKey")
  Future<List<Product>> getProductByCategory(int categoryKey);

  @Query('SELECT * FROM Product WHERE id = :id')
  Future<Product?> findProductByID(int id);

  @update
  Future<void> updateProduct(Product product);

  @Query('SELECT * FROM Product ORDER BY lastUpdated DESC')
  Future<List<Product>> getAllProductsSortedByDate();

  @Query('UPDATE Product SET discount = :discount WHERE loai = :loai')
  Future<void> updateDiscountForCategory(int loai, double discount);

  @Query('UPDATE Product SET discount = NULL WHERE loai = :loai')
  Future<void> clearDiscountForCategory(int loai);

  @Query('SELECT * FROM Product WHERE quantity < :threshold')
  Future<List<Product>> getProductsWithLowStock(int threshold);

  @Query('SELECT * FROM Product WHERE id = :id')
  Future<Product?> findProductById(int id);

  // Thêm hàm updateQuantity
  @Query('UPDATE Product SET quantity = :newQuantity WHERE id = :productId')
  Future<void> updateQuantity(int productId, int newQuantity);
}
