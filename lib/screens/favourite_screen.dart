import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';

class FavoriteScreen extends StatefulWidget {
  final List<Product> favoriteItems; // Nhận dữ liệu là List<Product>
  final Function(Product)
  onRemoveFavorite; // Callback để xóa sản phẩm khỏi danh sách yêu thích

  const FavoriteScreen({
    super.key,
    required this.favoriteItems,
    required this.onRemoveFavorite, // Truyền hàm xóa vào
  });

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.favoriteItems);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, widget.favoriteItems);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Favorite Items',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child:
                    widget.favoriteItems.isEmpty
                        ? const Center(child: Text('No favorite items yet'))
                        : ListView.builder(
                          itemCount: widget.favoriteItems.length,
                          itemBuilder: (context, index) {
                            final product = widget.favoriteItems[index];
                            return _buildFavoriteItem(product, index);
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(Product product, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Image.asset(
          product.imgURL,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(product.name),
        subtitle: Text(product.description),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            setState(() {
              widget.onRemoveFavorite(product);
            });
          },
        ),
      ),
    );
  }
}
