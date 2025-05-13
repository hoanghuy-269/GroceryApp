import 'package:flutter/material.dart';
import 'home.dart';
import 'favourite_screen.dart';
import 'account_screen.dart';

class MyBottom extends StatefulWidget {
  final String userEmail;

  const MyBottom({super.key, required this.userEmail});

  @override
  State<StatefulWidget> createState() => _MyBottomState();
}

class _MyBottomState extends State<MyBottom> {
  int _selected = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const Home(),
      const FavoriteScreen(),
      const Home(),
      AccountScreen(email: widget.userEmail),
    ];
  }

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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
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
