import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fourways/src/utils/toast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class GroupChatPage extends StatefulWidget {
  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  List messages = [];
  int userID = 0;


  final TextEditingController _controller = TextEditingController();
  Future<bool> sendMessage(String textMessage, [File? imageFile]) async {
    final url =
        'https://4waysproduction.co.za/mob_app/api/create_group_chat_message.php';
    var userID = await SessionManager().get("userID");
    var month_year = await SessionManager().get("month_year");
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Adding text fields to the post request
    request.fields['senderID'] = userID.toString();
    request.fields['month_year'] =
        month_year.toString(); // Fetch this value accordingly
    request.fields['textMessage'] = textMessage;

    // If an imageFile is provided, add it to the multipart request
    if (imageFile != null) {
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile('image', stream, length,
          filename: basename(imageFile.path));
      request.files.add(multipartFile);
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var responseBody = json.decode(responseData);

        if (!responseBody['error']) {
        setState(() {
           selectedImage = null;
        });
        
                await fetchGroupChatMessages();// If you want to implement a "load more" feature
               
          Toast.showToast("Message sent successfully!");
          return true;
        } else {
          Toast.showToast(responseBody['message']);
        }
      } else {
        Toast.showToast("Failed to send message.");
      }
    } catch (error) {
      print(error);
      Toast.showToast("An error occurred.");
    }

    return false;
  }

  Future<File?> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery); // or use ImageSource.camera for camera
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  Future<void> fetchGroupChatMessages() async {
    try {
      var month_year = await SessionManager().get("month_year");
      Uri url = Uri.parse(
          'https://4waysproduction.co.za/mob_app/api/fetch_group_messages.php');

      final response = await http.post(url, body: {
        "month_year": month_year.toString(),
      });

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (!jsonResponse['error']) {
          setState(() {
            messages = jsonResponse['data'];
          });
          print(messages);
        } else {
          print(jsonResponse['message']);
        }
      } else {
        print('Failed to load group chat messages');
      }
    } catch (error) {
      print('Error fetching group chat messages: $error');
    }
  }

  File? selectedImage;
  @override
  void initState() {
    super.initState();
    getUserID();
    fetchGroupChatMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
         RefreshIndicator(
  onRefresh: fetchGroupChatMessages,
  child: SingleChildScrollView(
    physics: AlwaysScrollableScrollPhysics(), // to ensure that it's always scrollable
    child: Container(
      padding: EdgeInsets.all(12),
      color: Colors.white,
      width: double.infinity,
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: const Text(
              'Group chat',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0190EE),
                fontSize: 30,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
),

          Expanded(
            child: ListView.builder(
            
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages[index];
                print(message['senderID'].toString());

                print(userID.toString());

                var isOwnMessage =
                    message['senderID'].toString() == userID.toString();

                return ChatBubble(
                  isOwnMessage: isOwnMessage,
                  textMessage: message['textMessage'],
                  imageMessage: message['imageURL'],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt), // For image upload
                  onPressed: () async {
                  
                    var image =
                        await _pickImage(); // Implement this function to use an image picker
                    setState(() {
                      selectedImage =
                          image; // Set selectedImage as the picked image
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage(_controller.text, selectedImage);
                    _controller.clear(); // Clear the text field
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  getUserID() async {
    userID = await SessionManager().get("userID");
  }
}

class ChatBubble extends StatelessWidget {
  final bool isOwnMessage;
  final String textMessage;
  final String? imageMessage;

  ChatBubble(
      {required this.isOwnMessage,
      required this.textMessage,
      this.imageMessage});

  @override
  Widget build(BuildContext context) {
    List<Widget> messageContent = [];

    if (imageMessage != null && imageMessage!.isNotEmpty) {
      messageContent.add(Image.network(imageMessage!));
    }

    if (textMessage.isNotEmpty) {
      messageContent.add(Text(textMessage));
    }

    return Align(
      alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isOwnMessage ? Colors.purple[300] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: messageContent,
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: GroupChatPage()));
