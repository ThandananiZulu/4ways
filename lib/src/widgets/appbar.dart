import 'package:flutter/material.dart';
import 'package:fourways/src/pages/friends.dart';

class Appbar extends StatelessWidget {
  const Appbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shadowColor: Colors.transparent,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          // Add your logo image here
          Image.asset(
            'assets/logo.png', // Replace with your image path
            width: 33, // Adjust the width as needed
            height: 33, // Adjust the height as needed
          ),
          const SizedBox(width: 10), // Add some spacing between logo and title
          const Text(
            '4WAYS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0190EE),
              fontSize: 30,
            ),
          ),
        ],
      ),
      actions: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey[100],
          child: IconButton(
              onPressed: () => print('search'),
              icon: const Icon(
                Icons.search,
                color: Colors.black,
                size: 26,
              )),
        ),
        const SizedBox(width: 20),
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey[100],
          child: IconButton(
            onPressed: () {
              // Navigate to the "Friends" page when the messages icon is pressed
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FriendsPage(), // Replace with your FriendsPage widget
                ),
              );
            },
            icon: const Icon(
              Icons.message_sharp,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 10)
      ],
    );
  }
}
