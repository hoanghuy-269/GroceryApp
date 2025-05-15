import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function(Product) onFavorite;
  final Function(Product) onAddToCart;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.product,
    required this.onFavorite,
    required this.onAddToCart,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: product.imgURL.startsWith('assets/')
                    ? Image.asset(
                        product.imgURL,
                        fit: BoxFit.cover,
                        height: 100,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50),
                      )
                    : Image.network(
                        product.imgURL,
                        fit: BoxFit.cover,
                        height: 100,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50),
                      ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: InkWell(
                  onTap: () => onFavorite(product),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${product.price.toStringAsFixed(3)} đ',
              style: const TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onAddToCart(product); // Gọi hàm onAddToCart từ HomeScreen
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.shopping_cart),
                        SizedBox(width: 8),
                        Text('Thêm vào giỏ'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
