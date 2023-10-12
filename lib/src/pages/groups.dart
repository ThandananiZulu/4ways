import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fourways/src/pages/friends.dart';
import 'package:fourways/src/pages/groupchat.dart';
import 'package:fourways/src/utils/toast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fourways/src/pages/ProfilePage.dart';
import 'package:fourways/src/pages/home_screen.dart';
import 'package:fourways/src/pages/menu.dart';
import 'package:fourways/src/pages/notifications.dart';
import 'package:fourways/src/utils/functions.dart';
import 'package:iconsax/iconsax.dart';

class Groups extends StatefulWidget {
  Groups({Key? key}) : super(key: key);

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
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

  // ! Declaration variable
  var index = 0;
  var color = Colors.blue;
  late TabController myControler;
  var like = Colors.black;
  var like2 = Colors.black;
  var likeComent = Colors.black;
  var likenumber = 45;
  var likenumber2 = 117;
  var likeGroups = 22;
  List groups = [];
  // ! ==========================
  @override
  void initState() {
    super.initState();
    setter();
  }

  setter() async {
    var result = await fetchGroups();
    setState(() {
      groups = result;
    });
  }

  fetchGroups() async {
    var userID = await SessionManager().get("userID");

    print(userID.toString());
    try {
      Uri url;

      url = Uri.parse(
          'https://4waysproduction.co.za/mob_app/api/fetch_groups.php');
      final response =
          await http.post(url, body: {"userID": userID.toString()});

      if (response.statusCode == 200) {
        var r = json.decode(response.body);
        print("groups");
        print(r['data']);
        return r['data'];
      }
    } catch (error) {
      Toast.showToast("Something went wrong");
      print(error);
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Wrap your widget with a Scaffold
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
        body: Container(
          color: Colors.grey[350],
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  color: Colors.white,
                  width: double.infinity,
                  height: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: const Text(
                          'Groups',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0190EE),
                            fontSize: 30,
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: 80,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     children: [
                      //       CircleAvatar(
                      //         backgroundColor: Colors.grey[300],
                      //         child: IconButton(
                      //           onPressed: () {},
                      //           icon: Icon(Icons.add),
                      //           color: Colors.black,
                      //           iconSize: 26,
                      //         ),
                      //       ),
                      //       CircleAvatar(
                      //         backgroundColor: Colors.grey[300],
                      //         child: IconButton(
                      //           onPressed: () {},
                      //           icon: Icon(Icons.search),
                      //           color: Colors.black,
                      //           iconSize: 26,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 600,
                  margin: EdgeInsets.only(top: 15),
                  child: ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> group = groups[index];
                      return Column(
                        children: [
                          ListTile(
                            onTap: () async {
                              var sessionManager = SessionManager();
                              await sessionManager.remove("month_year");
                              await sessionManager.set(
                                  "month_year", group['month_year']);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GroupChatPage()),
                              );
                            },
                            isThreeLine: false,
                            title: Text(group['month_year']),
                            subtitle: Text(group['month_year']),
                            trailing: Icon(Icons.more_horiz),
                            leading: Container(
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: AssetImage("assets/group1.webp"),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 100,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Container(
                                //     margin: EdgeInsets.only(left: 10),
                                //     child: Text("👍😅🥰  $likeGroups k ",
                                //         style: TextStyle(fontSize: 17))),
                                // Container(
                                //     margin: EdgeInsets.only(right: 10),
                                //     child: Text(
                                //       "246 Comments",
                                //       style: TextStyle(fontSize: 17),
                                //     )),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 2,
                            margin: EdgeInsets.only(top: 20),
                            color: Colors.black12,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
