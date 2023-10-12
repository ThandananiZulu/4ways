// ignore_for_file: file_names
import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fourways/src/data/data.dart';
import 'package:flutter/material.dart';
import 'package:fourways/src/models/models.dart';
import 'package:fourways/src/pages/comment_screen.dart';
import 'package:fourways/src/utils/functions.dart';
import 'package:fourways/src/utils/toast.dart';
import 'package:http/http.dart' as http;

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  Map likePostData = {"postId": "", "postUserId": "", "loggedInUserId": ""};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> likePost(int postuserid, int postid, int index) async {
    var userID = await SessionManager().get("userID");
    likePostData["postId"] = postid;
    likePostData["postUserId"] = postuserid;
    likePostData["loggedInUserId"] = userID;
    final url =
        Uri.parse('https://4waysproduction.co.za/mob_app/api/like_post.php');

    try {
      var request = http.MultipartRequest('POST', url);

      request.fields['postid'] = likePostData["postId"].toString();
      request.fields['postuserid'] = likePostData["postUserId"].toString();
      request.fields['loggeduserid'] =
          likePostData["loggedInUserId"].toString();

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();

        if (responseData != null && responseData.isNotEmpty) {
          var r = json.decode(responseData);

          if (r['error'] == false) {
            if (r['message'] == "Post liked successfully") {
              setState(() {
                posts[index].likes += 1;
              });
            }
            if (r['message'] == "Post unliked successfully") {
              setState(() {
                posts[index].likes -= 1;
              });
            }
            Toast.showToast(r['message']);
          } else {
            Toast.showToast(r['message']);
          }
        } else {
          Toast.showToast("Something went wrong");
        }
      } else {
        print('Failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      Toast.showToast("Something went wrong");
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      childCount: posts.length,
      (context, index) {
        return Container(
          margin: const EdgeInsets.only(top: 15),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          NetworkImage(posts[index].user!.imageUrl!),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 80,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(posts[index].user!.name!),
                                Text(
                                  '${posts[index].timeAgo!}' ' •🌎',
                                  style: TextStyle(color: Colors.grey[700]),
                                )
                              ],
                            ),
                            IconButton(
                                onPressed: () => print('menu'),
                                icon: const Icon(Icons.more_horiz))
                          ]),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(posts[index].caption!)),
              ),
              const SizedBox(
                height: 10,
              ),
              if (posts[index].imageUrl != null)
                Image.network(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  posts[index].imageUrl!,
                  fit: BoxFit.cover,
                ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: const Icon(
                            Icons.thumb_up_sharp,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(posts[index].likes.toString()),
                      ],
                    ),
                    Row(
                      children: [
                        Text('${posts[index].comments.toString()} comments'),
                        const SizedBox(width: 10),
                        Text('${posts[index].shares.toString()} shares'),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                     
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => likePost(
                            posts[index].user.userID, posts[index].id, index),
                        icon: const Icon(Icons.thumb_up_outlined),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text('Like'),
                    ],
                  ),
                  Row(
                    children: [
                     
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
    ));
  }
}
