import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fourways/src/data/data.dart';
import 'package:fourways/src/models/models.dart';
import 'package:fourways/src/pages/friends.dart';
import 'package:fourways/src/pages/home_screen.dart';
import 'package:fourways/src/utils/functions.dart';
import 'package:fourways/src/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fourways/src/utils/toast.dart';

class CreatePostContainer extends StatefulWidget {
  final User currentUser;

  CreatePostContainer({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  _CreatePostContainerState createState() => _CreatePostContainerState();
}

class _CreatePostContainerState extends State<CreatePostContainer> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController userIDController = TextEditingController();
  TextEditingController imageController =
      TextEditingController(); // Add this line
  bool isLoading = false;
  File? _image;
  // late final User currentUser = const User(name: '', imageUrl: '');

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        // Set the image path to the imageController
        imageController.text = _image.toString();
      });
    }
  }

  Future<void> handlePost() async {
    String name = await SessionManager().get("name");
    String surname = await SessionManager().get("surname");
    var user_id = await SessionManager().get("userID");

    setState(() {
      isLoading = true;
    });
    final url =
        Uri.parse('https://4waysproduction.co.za/mob_app/api/create_post.php');

    try {
      String filePath = imageController.text;
      var request = http.MultipartRequest('POST', url);
      print("Wow");
      print(filePath);
      if (filePath != '') {
        if (filePath.startsWith("File: '") && filePath.endsWith("'")) {
          filePath = filePath.substring(7, filePath.length - 1);
        }
        

        request.files
            .add(await http.MultipartFile.fromPath('image_path', filePath));
      }
      request.fields['name'] = name.toString();
      request.fields['surname'] = surname.toString();
      request.fields['post'] = postController.text.toString();
      request.fields['user_id'] = user_id.toString();
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        setState(() {
          isLoading = false;
        });
        if (responseData != null && responseData.isNotEmpty) {
          var r = json.decode(responseData);

          if (r['error'] == false) {
            Toast.showToast(r['message']);
            List<Post> fetchAllPosts = await fetchPosts();
            setState(() {
              posts = fetchAllPosts;
            });
      
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            Toast.showToast(r['message']);
          }
        } else {
          Toast.showToast("Something went wrong");
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      Toast.showToast("Something went wrong");
      print(error);
      setState(() {
        isLoading = false;
      });
    }
  }

  getter() async {
    String name = await SessionManager().get("name");
    String surname = await SessionManager().get("surname");
    int user_id = await SessionManager().get("userID");
    // Display the retrieved value in the text controller
    setState(() {
      nameController.text = "$name ";
      surnameController.text = " $surname";
      userIDController.text = " $user_id";
    });
  }

  fetchPosts() async {
    var userID = await SessionManager().get("userID");
    List<Post> newPosts = [];
    Functions functions = Functions();
    print(userID.toString());
    try {
      Uri url;

      url = Uri.parse(
          'https://4waysproduction.co.za/mob_app/api/fetch_posts.php');
      final response =
          await http.post(url, body: {"userID": userID.toString()});

      if (response.statusCode == 200) {
        var r = json.decode(response.body);

        for (var postData in r['data']) {
          DateTime postDate = DateTime.parse(postData['post_date']);
          String formattedTimeAgo = functions.timeAgo(postDate);
          print(postData);
          print("thankx");
          User postUser = User(
            userID: postData['users_id'],
            name: postData['user_first_name'],
            imageUrl: postData['image_path'],
          );
          User meUser = User(
            userID: postData['users_id'],
            name: postData['user_first_name'],
            imageUrl: postData['image_path'],
          );
          newPosts.add(Post(
            id: postData['post_id'],
            user: postData['users_id'] == userID
                ? meUser
                : postUser, // Assuming you still want to use the same user for all posts
            caption: postData['content'],
            timeAgo: formattedTimeAgo,
            imageUrl: postData['post_image'],
            likes: postData['likes'] ?? 0,
            comments: 0,
            shares: 0,
          ));
        }
        return newPosts;
      }
    } catch (error) {
      Toast.showToast("Something went wrong");
      print(error);
    }

    return newPosts;
  }

  @override
  void initState() {
    super.initState();
    getter();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      appBar: AppBar(
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
            const SizedBox(
                width: 10), // Add some spacing between logo and title
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
                    builder: (context) =>
                        FriendsPage(), // Replace with your FriendsPage widget
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
      ),
      body: Card(
        margin: EdgeInsets.symmetric(horizontal: isDesktop ? 5.0 : 0.0),
        elevation: isDesktop ? 1.0 : 0.0,
        shape: isDesktop
            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
            : null,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  ProfileAvatar(imageUrl: widget.currentUser.imageUrl),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                      height: 50.0,
                      child: TextField(
                        controller: postController,
                        maxLines: null,
                        decoration: InputDecoration.collapsed(
                          hintText: 'What\'s on your mind?',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 10.0, thickness: 0.5),
              ElevatedButton(
                onPressed: () => handlePost(),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF0190EE),
                ),
                child: Text('Send Post'),
              ),
              if (_image != null) Image.file(_image!, width: 100, height: 100),
              const SizedBox(
                  height: 10.0), // Add spacing between text field and button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => print('Live'),
                    icon: const Icon(
                      Icons.videocam,
                      color: Colors.red,
                    ),
                    label: Text('Live'),
                  ),
                  const VerticalDivider(width: 8.0),
                  TextButton.icon(
                    onPressed: () {
                      _pickImage(); // Call the _pickImage function when the "Photo" button is pressed
                    },
                    icon: const Icon(
                      Icons.photo_library,
                      color: Colors.green,
                    ),
                    label: Text('Photo'),
                  ),
                  const VerticalDivider(width: 8.0),
                  TextButton.icon(
                    onPressed: () => print('Video'),
                    icon: const Icon(
                      Icons.video_call,
                      color: Colors.purpleAccent,
                    ),
                    label: Text('Video'),
                  ),
                  // Display the selected image
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
