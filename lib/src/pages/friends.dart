import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fourways/src/models/global.dart';
import 'package:fourways/src/pages/directchat.dart';
import 'package:fourways/src/pages/groups.dart';
import 'package:fourways/src/pages/home_screen.dart';
import 'package:fourways/src/pages/menu.dart';
import 'package:fourways/src/pages/notifications.dart';
import 'package:fourways/src/utils/toast.dart';
import 'package:fourways/src/widgets/PageTitle.dart';
import 'package:flutter/material.dart';
import 'package:fourways/src/widgets/chat.dart';

import 'package:http/http.dart' as http;

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
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

  get text => null;
  get isUser => null;
  List users = [];
  String role = "";
  int userID = 0;
  Future<void> fetchUsers() async {
    try {
      Uri url = Uri.parse(
          'https://4waysproduction.co.za/mob_app/api/fetch_all_users.php');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var r = json.decode(response.body);
        print(r);

        if (r['status'] == 'success') {
          setState(() {
            users = r["users"];
          });
        } else {
          Toast.showToast(r['message']);
        }
      }
    } catch (error) {
      Toast.showToast("Something went wrong");
      print(error);
    }
  }

  setRole() async {
    role = await SessionManager().get("role");
    userID = await SessionManager().get("userID");
  }

  @override
  void initState() {
    super.initState();
    setRole();
    fetchUsers();
  }

  @override
  void dispose() {
    // Add your disposal logic here

    super.dispose();
  }
Future<bool> showDeleteConfirmation(BuildContext context, String name) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Removal'),
              content: RichText(
  text: TextSpan(
   style: TextStyle(
                    color: Colors.black, // Set the text color
                    fontSize: 14, // Set the font size
                  ),
    children: <TextSpan>[
      TextSpan(text: 'Are you sure you want to remove'),
    
      TextSpan(text: ' '),
      TextSpan(text: name, style: TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: ' '),
      TextSpan(text: 'from the system? This action is irreversible.'),
    ],
  ),
),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Returns false
                  },
                ),
                TextButton(
                  child: Text('Delete'),
                  onPressed: () {
                    Navigator.of(context).pop(true); // Returns true
                  },
                ),
              ],
            );
          },
        ) ??
        false; // In case the user dismisses the dialog by clicking outside, return false
  }

  Future<void> deleteUser(int userID) async {
    final String apiUrl =
        "https://4waysproduction.co.za/mob_app/api/delete_user.php";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'userID': userID.toString(),
        },
      );

      var result = json.decode(response.body);
      if (result['status'] == 'success') {
        Toast.showToast(result['message']);
      } else {
        Toast.showToast(result['message']);
        // Handle the error appropriately. Maybe show a toast or snackbar.
      }
    } catch (error) {
      print('Error: $error');
      Toast.showToast("Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: PageTitle(title: 'Members'),
            backgroundColor: Colors.white,
            centerTitle: false,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _getFriendsFiter(),
              const Divider(),
              _getFriendSuggestions(),
            ]),
          )
        ],
      ),
    );
  }

  Widget _getSectionHeader(String title) {
    return Container(
      decoration: const BoxDecoration(
          //color: Colors.purple,
          ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _getFirendAvatar() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 100, maxHeight: 100),
      decoration: const BoxDecoration(
          // color: Colors.green,
          ),
      child: CircleAvatar(
        backgroundImage: NetworkImage(userProfileImage),
        radius: 60.0,
      ),
    );
  }

  Widget _getFriendsFiter() {
    return Container(
      decoration: const BoxDecoration(
          //  color: Colors.pink,
          ),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(right: 10),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: const Color(0xffEBECF0),
              splashFactory: NoSplash.splashFactory,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('All Members',
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _getFriendSuggestions() {
    return Container(
      decoration: const BoxDecoration(
          //color: Colors.yellow,
          ),
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        children: <Widget>[
          _getSectionHeader('People you may know'),
          const Padding(
            padding: EdgeInsets.all(5),
          ),
          ...users.map((user) {
            
            if (userID.toString() != user['id'].toString()) {
              return _getFriendSuggestion(user['first_name'],
                  user['profile_image_url'], role, user['id']);
            }
            return Container();
          }).toList(),
        ],
      ),
      // height: 400,
    );
  }

  Widget _getFriendSuggestion(
      String name, String profileImage, String role, int userIDs) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(maxWidth: 100, maxHeight: 100),
            child: CircleAvatar(
              backgroundImage: NetworkImage(profileImage),
              radius: 60.0,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10),
          ),
          Expanded(
            flex: 5,
            child: Container(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DirectChatPage(data: {
                                        "senderID": userID.toString(),
                                        "receiverID": userIDs.toString()
                                      })),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: const Color(0xFF022F68),
                            splashFactory: NoSplash.splashFactory,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Message',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                      ),
                      if (role == 'admin')
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                          
                              bool shouldDelete =
                                  await showDeleteConfirmation(context,name);
                              if (shouldDelete) {
                               await deleteUser(userIDs);
                               await fetchUsers();
                              }
                              
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: const Color(0xffDCDDDF),
                              splashFactory: NoSplash.splashFactory,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Remove',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
