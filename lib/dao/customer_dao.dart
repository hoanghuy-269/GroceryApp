import 'package:floor/floor.dart';
import '../models/Customer.dart';

@dao
abstract class CustomerDao {
  @Query('SELECT * FROM customers')
  Future<List<Customer>> getAllCustomers();

  @Query('SELECT * FROM customers WHERE id = :id')
  Future<Customer?> getCustomerById(int id);

  @Query('SELECT * FROM customers WHERE phone = :phone LIMIT 1')
  Future<Customer?> getCustomerByPhone(String phone);

  @insert
  Future<int> insertCustomer(Customer customer);

  @update
  Future<int> updateCustomer(Customer customer);

  @delete
  Future<int> deleteCustomer(Customer customer);
}
