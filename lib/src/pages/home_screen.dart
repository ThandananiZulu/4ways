import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fourways/src/models/models.dart';
import 'package:fourways/src/pages/friends.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fourways/src/pages/ProfilePage.dart';
import 'package:fourways/src/pages/groups.dart';
import 'package:fourways/src/pages/menu.dart';
import 'package:fourways/src/pages/notifications.dart';
import 'package:fourways/src/utils/toast.dart';
import '../data/data.dart';
import '../widgets/appbar.dart';
import '../widgets/posts.dart';
import '../widgets/create_post.dart';
import '../widgets/create_room.dart';
import '../widgets/media.dart';
import '../widgets/stories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    Groups(),
    NotificationsPage(),
    FriendsPage(),
    MenuPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Check if the index corresponds to a valid destination
    if (destinationIndices.contains(index)) {
      // Use Navigator to navigate to the destination
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => screens[index]),
      );
    }
  }

  final List<int> destinationIndices = [0, 1, 2, 3, 4];
  
  // void fetchProfileImage() async {
  //   var profileImage = await SessionManager().get("profile");
  //   var name = await SessionManager().get("username");
  //   print("wow");
  //   if (profileImage != null) {
  //     setState(() {
  //       currentUser = User(name: name, imageUrl: profileImage);
  //     });
  //   }
  // }

  // fetchUser() async {
  //   var email = await SessionManager().get("username");
  //   print(email.toString());
  //   try {
  //     Uri url;

  //     url =
  //         Uri.parse('https://4waysproduction.co.za/mob_app/api/fetch_user.php');
  //     final response = await http.post(url, body: {"email": email.toString()});

  //     if (response.statusCode == 200) {
  //       var r = json.decode(response.body);
  //       print(r);
  //       var sessionManager = SessionManager();
  //       await sessionManager.set("name", r["name"].toString());
  //       await sessionManager.set("surname", r["surname"].toString());
  //       await sessionManager.set("profile", r["profile_image_url"].toString());
  //       await sessionManager.set("userID", r["userID"].toString());

  //       if (r['error'] == false) {
  //       } else {
  //         Toast.showToast(r['message']);
  //       }
  //     }
  //   } catch (error) {
  //     Toast.showToast("Something went wrong");
  //     print(error);
  //   }

  //   return [];
  // }

  @override
  void initState() {
    super.initState();
    // fetchUser();
    // fetchProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (value) => _onTabTapped(value),
        unselectedItemColor: Colors.grey,
        selectedItemColor: Color(0xFF0190EE),
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: '')
        ],
      ),
      body:  CustomScrollView(
        slivers: [
          Appbar(),
          SliverToBoxAdapter(
            child: CreatePost(),
          ),
          SliverToBoxAdapter(
            child: Media(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 15,
            ),
          ),
          SliverToBoxAdapter(
            child: CreateRoom(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 15,
            ),
          ),
          SliverToBoxAdapter(
            child: Stories(),
          ),
          Posts()
        ],
      ),
    );
  }
}
