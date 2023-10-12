import 'package:flutter/material.dart';
import 'package:fourways/src/pages/ProfilePage.dart';
import 'package:fourways/src/pages/friends.dart';
import 'package:fourways/src/pages/groups.dart';
import 'package:fourways/src/pages/home_screen.dart';
import 'package:fourways/src/pages/menu.dart';
import 'package:fourways/src/pages/notifications.dart';

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _currentIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    Groups(),
    NotificationsPage(),
     FriendsPage(),
    MenuPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            _currentIndex = value; // Change the active screen index
          });
        },
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),            
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: '')
        ],
      ),
    );
  }
}
