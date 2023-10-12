import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:fourways/src/models/global.dart';
import 'package:fourways/src/pages/ProfilePage.dart';
import 'package:fourways/src/pages/directchat.dart';
import 'package:fourways/src/pages/friends.dart';
import 'package:fourways/src/pages/groups.dart';
import 'package:fourways/src/pages/home_screen.dart';
import 'package:fourways/src/pages/menu.dart';
import 'package:fourways/src/utils/toast.dart';
import 'package:fourways/src/widgets/PageTitle.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
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

  bool hasNotification = false;
  List directChats = [];
  String userID = "";
  @override
  void initState() {
    super.initState();
    fetchAndSetDirectChatMessages();
  }

  fetchAndSetDirectChatMessages() async {
    var fetchedChats = await fetchDirectChatMessages();
    setState(() {
      directChats = fetchedChats;
    });
  }

  Future<List> fetchDirectChatMessages() async {
    var userIDs = await SessionManager().get("userID");
    userID = userIDs.toString();
    print(userIDs.toString());
    try {
      Uri url = Uri.parse(
          'https://4waysproduction.co.za/mob_app/api/fetch_directchat_messages.php');
      final response =
          await http.post(url, body: {"userID": userIDs.toString()});

      if (response.statusCode == 200) {
        var r = json.decode(response.body);
        print("Direct Chat Messages:");
        print(r['data']);
        print(r['message']);
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
        backgroundColor: Colors.grey[300],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (value) => _onTabTapped(value),
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.blue,
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
        body: RefreshIndicator(
          onRefresh: () async {
           List fetched = await fetchDirectChatMessages();
            setState(() {
              directChats = fetched;
            });
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: PageTitle(title: 'Messages'),
                backgroundColor: Colors.white,
                centerTitle: false,
                actions: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(_getNotifications()),
              ),
            ],
          ),
        ));
  }

  List<Widget> _getNotifications() {
    List<Widget> notifications = [];

    for (var chat in directChats) {
      notifications.add(_getNotification(
          ' ${chat['first_name']} ${chat['last_name']}',
          chat['last_timestamp'],
          chat['last_message'],
          chat['chatUserID'],
          false // By default, assuming no story attached. Adjust this based on your needs.
          ));
    }

    return notifications;
  }

  Widget _getNotification(String notificaiton, String timestamps,
      String message, int chatUserID, bool hasStory) {
    DateTime timestamp = DateTime.tryParse(timestamps) ?? DateTime.now();
    String formattedTime;

    // Check if the timestamp is from today, if yes, only show the time, otherwise show the date
    if (DateUtils.isSameDay(DateTime.now(), timestamp)) {
      formattedTime = DateFormat('h:mm a').format(timestamp);
    } else {
      formattedTime = DateFormat('MM/dd/yyyy').format(timestamp);
    }

    return Container(
      decoration: BoxDecoration(
          color: (hasStory == true)
              ? Theme.of(context).highlightColor
              : Colors.transparent),
      child: ListTile(
        title: Text(
          notificaiton,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
              userProfileImage), // Adjust this to reflect the sender's image
          radius: 28.0,
        ),
        subtitle: Text(
          message,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        isThreeLine: true,
        trailing: Text(
          formattedTime,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DirectChatPage(data: {
                      "senderID": userID.toString(),
                      "receiverID": chatUserID.toString()
                    })),
          );
          setState(() {
            hasStory = (hasStory == true) ? false : true;
          });
        },
      ),
    );
  }
}
