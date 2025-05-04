import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // Danh sách các mục yêu thích
  List<Map<String, String>> favoriteItems = [
    {'title': 'Item 1', 'description': 'Description for item 1'},
    {'title': 'Item 2', 'description': 'Description for item 2'},
    {'title': 'Item 3', 'description': 'Description for item 3'},
  ];

  void _removeFavorite(int index) {
    setState(() {
      favoriteItems.removeAt(index); // Xóa mục yêu thích
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
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
            // Danh sách các mục yêu thích
            Expanded(
              child: ListView.builder(
                itemCount: favoriteItems.length,
                itemBuilder: (context, index) {
                  return _buildFavoriteItem(
                    favoriteItems[index]['title']!,
                    favoriteItems[index]['description']!,
                    index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(String title, String description, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _removeFavorite(index); // Gọi hàm xóa mục yêu thích
          },
        ),
      ),
    );
  }
}
