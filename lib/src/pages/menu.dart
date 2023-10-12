import 'package:fourways/src/models/global.dart';
import 'package:fourways/src/pages/ProfilePage.dart';
import 'package:fourways/src/pages/friends.dart';
import 'package:fourways/src/pages/groups.dart';
import 'package:fourways/src/pages/home_screen.dart';
import 'package:fourways/src/pages/login.dart';
import 'package:fourways/src/pages/notifications.dart';
import 'package:fourways/src/widgets/menuTitle.dart';
import 'package:flutter/material.dart';
import 'package:fourways/src/widgets/posts.dart';
import '../widgets/PageTitle.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key? key}) : super(key: key); 

  @override
  _MenuPageState createState() => _MenuPageState();
}
GestureDetector buildMenuItem(String title, IconData icon, Function() onTapHandler) {
  return GestureDetector(
    onTap: onTapHandler,
    child: ListTile(
      title: MenuTitle(title: title),
      leading: Icon(
        icon,
        size: 35,
        color: Colors.blueGrey[300],
      ),
    ),
  );
}

class _MenuPageState extends State<MenuPage> {  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: PageTitle(title: 'Menu'),
            backgroundColor: Colors.white,
            centerTitle: false,
          ),
          
          SliverList(
            delegate: SliverChildListDelegate([
              buildMenuItem('$firstName $lastName', Icons.account_circle, () {
              // Navigate to the profile page
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
              }),
              Divider(),
              buildMenuItem('Posts', Icons.outlined_flag, () {
                // Navigate to the Posts page
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Posts()));
              }),
              Divider(),
              buildMenuItem('Friends', Icons.people_outline, () {
                // Navigate to the Friends page
                Navigator.push(context, MaterialPageRoute(builder: (context) => FriendsPage()));
              }),
              
              Divider(),
              buildMenuItem('Groups', Icons.group_work, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Groups()));
              }),
              Divider(),                            
              ListTile(
                title: MenuTitle(title: 'Memories'),
                leading: Icon(
                  Icons.outlined_flag,
                  size: 35,
                  color: Colors.blueGrey[300],
                ),
                onTap: () {},
              ),
              Divider(),                            
              ListTile(
                title: MenuTitle(title: 'Jobs'),
                leading: Icon(
                  Icons.work,
                  size: 35,
                  color: Colors.blueGrey[300],
                ),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                title: MenuTitle(title: 'Local'),
                leading: Icon(
                  Icons.location_on,
                  size: 35,
                  color: Colors.blueGrey[300],
                ),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                title: MenuTitle(title: 'Nearby Friends'),
                leading: Icon(
                  Icons.perm_identity,
                  size: 35,
                  color: Colors.blueGrey[300],
                ),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                title: MenuTitle(title: 'Discover people'),
                leading: Icon(
                  Icons.perm_contact_calendar,
                  size: 35,
                  color: Colors.blueGrey[300],
                ),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                title: MenuTitle(title: 'See more'),
                leading: Icon(
                  Icons.more,
                  size: 35,
                  color: Colors.blueGrey[300],
                ),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                title: MenuTitle(title: 'Help & Support'),
                leading: Icon(
                  Icons.help_outline,
                  size: 35,
                  color: Colors.blueGrey[300],
                ),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                title: MenuTitle(title: 'Settings & Privacy'),
                leading: Icon(
                  Icons.settings,
                  size: 35,
                  color: Colors.blueGrey[300],
                ),
                onTap: () {},
              ),
              const Divider(),
              buildMenuItem('Log Out', Icons.power_settings_new, () {
                // Perform the log out action here
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));                
              }),
              Divider(),
            ]),
          )
        ],
      ),
    );
  }
}
