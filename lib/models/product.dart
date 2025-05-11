
class Product {
  Product({
    required this.name,
    required this.imgURL,
    required this.price,
    required this.quantity,
    required this.description,
  });
  String name;
  String imgURL;
  double price;
  int quantity;
  String description;

  // chuyển đổi đối tượng thành Map lưu vào cơ sở dữ liệu

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': imgURL,
      'price': price,
      'quantity': quantity,
      'description': description,
    };
  }

  // hàm khởi tạo Product từ Map ( lấy dữ liệu từ cỏ sở dữ liêu )
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'],
      imgURL: map['image'],
      price: map['price'],
      quantity: map['quantity'],
      description: map['description'],
    );
  }
}
