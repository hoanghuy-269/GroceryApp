import 'package:flutter/material.dart';
import 'home.dart';
// import 'product_detal_screen.dart';
import 'favourite_screen.dart';

class MyBottom extends StatefulWidget {
  const MyBottom({super.key});

  @override
  State<StatefulWidget> createState() => _MyBottomState();
}

class _MyBottomState extends State<MyBottom> {
  int _selected = 0;

  final List<Widget> _screens = [
    const Home(),
    const FavoriteScreen(),
    const Home()


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selected],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selected,
        onTap: _onPress,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
        ],
      ),
    );
  }

  void _onPress(int index) {
    setState(() {
      _selected = index;
    });
  }
}
