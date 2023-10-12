import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fourways/src/pages/friends.dart';
import 'package:fourways/src/pages/groups.dart';
import 'package:fourways/src/pages/home_screen.dart';
import 'package:fourways/src/pages/menu.dart';
import 'package:fourways/src/pages/notifications.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (value) => _onTabTapped(value),
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
      body: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
              return <Widget>[
                
              ];
            },
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(alignment: Alignment.centerLeft, children: <Widget>[
                Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      color: Colors.blue,
                      height: 180,
                      child: Image.asset(
                        "assets/profile1.webp",
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    )
                  ),
                  Positioned(
                    left: (MediaQuery.of(context).size.width / 2) - 60,
                    top: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset(
                        "assets/profile2.webp",
                        height: 120,
                        width: 120,
                      ),
                    )
                  ),
                  Positioned(
                    left: (MediaQuery.of(context).size.width / 2) - 60,
                    top: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset(
                        "assets/profile3.webp",
                        height: 120,
                        width: 120,
                      ),
                    )
                  ),
                  Positioned(
                    left: 0,
                    top: 242,
                    child: SizedBox(
                      height: 700,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: const Column(
                              children: [
                                Text(
                                  "Youssef Marzouk",
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "Software Engineer",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffbbbbbb)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "2.8K",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "followers",
                                style: TextStyle(color: Color(0xff646568)),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Text(
                                "864",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "friends",
                                style: TextStyle(color: Color(0xff646568)),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xff2177ee),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Color(0xff2177ee).withOpacity(.4),
                                          blurRadius: 5.0,
                                          offset: Offset(0, 10),
                                          // shadow direction: bottom right
                                        )
                                      ]),
                                  width: 145,
                                  height: 38,
                                  child: const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person_add_rounded,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "Add friend",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xffeff0f1),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Color(0xffeff0f1).withOpacity(.4),
                                          blurRadius: 5.0,
                                          offset: Offset(0, 10),
                                          // shadow direction: bottom right
                                        )
                                      ]),
                                  width: 145,
                                  height: 38,
                                  child: const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Iconsax.message5,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "Message",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    width: 56,
                                    height: 38,
                                    child: Icon(Icons.more_horiz)),
                              ]),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.all(18),
                            width: MediaQuery.of(context).size.width,
                            color: const Color(0xffeff0f2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 3, bottom: 3),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Iconsax.location5,
                                        color: Color(0xff80889b),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "From Durban, KZN ",
                                        style: TextStyle(fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 3, bottom: 3),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Image.asset(
                                        "assets/icon/icon.png",
                                        height: 20,
                                        width: 20,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text(
                                        "wiseman_dlungwana",
                                        style: TextStyle(fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 3, bottom: 3),
                                  child: const Row(
                                    children: [
                                      Icon(Iconsax.personalcard,
                                          color: Color(0xff80889b)),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "See full Info ",
                                        style: TextStyle(fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                            child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Group",
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "864 · 3 Mutual friends",
                                    style: TextStyle(
                                      color: Color(0xffacacae),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffeff0f1),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xffeff0f1)
                                      .withOpacity(.4),
                                      blurRadius: 5.0,
                                      offset: Offset(0, 10),
                                      // shadow direction: bottom right
                                    )
                                  ]
                                ),
                                width: (MediaQuery.of(context).size.width /2) - 50,
                                height: 38,
                                child: const Center(
                                  child: Text(
                                    "See all friends",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),                         
                      ],
                    ),
                  )
                )
              ]),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2.0,
                  offset: Offset(0, 2),
                // shadow direction: bottom right
                )
              ]
            ),
                padding: EdgeInsets.fromLTRB(10, 25, 10, 5),
                height: 90,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    GestureDetector(
                        child: Icon(Icons.arrow_back),
                        onTap: () => Navigator.pop(context)),
                    const SizedBox(
                      width: 5,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 54,
                      height: 40.0,
                      padding: EdgeInsets.all(10),
                      // margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.0),
                        color: Colors.grey.shade300,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 3.0,
                            offset: Offset(1, 1),
                            // shadow direction: bottom right
                          )
                        ],
                      ),
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Iconsax.search_normal,
                                  color: Color(0xff65676b),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  "Search",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xff65676b),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
