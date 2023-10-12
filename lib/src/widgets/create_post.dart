import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fourways/src/data/data.dart';
import 'package:flutter/material.dart';
import 'package:fourways/src/models/models.dart';
import 'package:fourways/src/pages/home_screen.dart';
import 'package:fourways/src/utils/functions.dart';
import 'package:fourways/src/utils/toast.dart';
import 'package:fourways/src/widgets/create_post_container.dart';
import 'package:http/http.dart' as http;
class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
 

  Future<void> _handleRefresh() async {
    List<Post> fetchAllPosts = await fetchPosts();
    List<Story> fetchAllStories = await fetchStories();

    var profileImage = await SessionManager().get("profile");
    var name = await SessionManager().get("username");
    var userID = await SessionManager().get("userID");

    setState(() {
      currentUser = User(userID: userID, name: name, imageUrl: profileImage);
      posts = fetchAllPosts;
      stories = fetchAllStories;
    });

    // Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }


 
  fetchPosts() async {
    var userID = await SessionManager().get("userID");
    Functions functions = Functions();
    List<Post> newPosts = [];
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

  fetchStories() async {
    var userID = await SessionManager().get("userID");
    List<Story> newStories = [];
    Functions functions = Functions();
    print(userID.toString());
    try {
      Uri url = Uri.parse(
          'https://4waysproduction.co.za/mob_app/api/fetch_stories.php');
      final response =
          await http.post(url, body: {"userID": userID.toString()});

      if (response.statusCode == 200) {
        var r = json.decode(response.body);
        for (var storyData in r['data']) {
          DateTime storyDate = DateTime.parse(storyData[
              'story_date']); // Note the change from 'post_date' to 'story_date'
          String formattedTimeAgo = functions.timeAgo(storyDate);
          User storyUser = User(
            userID: storyData['users_id'],
            name: storyData['user_first_name'],
            imageUrl: storyData['image_path'],
          );
          User meUser = User(
            userID: storyData['users_id'],
            name: storyData['user_first_name'],
            imageUrl: storyData['image_path'],
          );
          newStories.add(Story(
            user: storyData['users_id'] == userID ? meUser : storyUser,
            imageUrl: storyData['story_image'],
            isViewed: false,
          ));
        }
        return newStories;
      }
    } catch (error) {
      Toast.showToast("Something went wrong");
      print(error);
    }
    return newStories;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the CreatePost container or screen here
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CreatePostContainer(
              currentUser: currentUser,
            ),
          ),
        );
      },
      child: RefreshIndicator(
          onRefresh:
              _handleRefresh, // This function will handle the refresh logic
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          height: 75,
          color: Colors.white,
          child:  Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(currentUser.imageUrl),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 105,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CreatePostContainer(
                                  currentUser: currentUser,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            onPrimary: Colors.black,
                            elevation: 0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'What\'s on your mind?',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
          )),
    );
  }
}
