import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fourways/src/utils/toast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class DirectChatPage extends StatefulWidget {
  final Map data;
  const DirectChatPage({Key? key, required this.data}) : super(key: key);

  @override
  _DirectChatPageState createState() => _DirectChatPageState();
}

class _DirectChatPageState extends State<DirectChatPage> {
  List messages = [];
  int userID = 0;

  final TextEditingController _controller = TextEditingController();
  Future<bool> sendMessage(String textMessage, [File? imageFile]) async {
    final url =
        'https://4waysproduction.co.za/mob_app/api/create_direct_message.php';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Adding text fields to the post request
    request.fields['senderID'] = widget.data["senderID"];
    request.fields['receiverID'] =  widget.data["receiverID"];
    request.fields['message'] = textMessage;

    // If an imageFile is provided, add it to the multipart request
    if (imageFile != null) {
      if (imageFile.lengthSync() > 10485760) {
        // Check if the image is larger than 10MB
        Toast.showToast("Image size exceeds the limit (10MB).");
        return false;
      }

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

        if (responseBody != null && !responseBody['error']) {
          setState(() {
            selectedImage = null;
          });

          await fetchDirectChatMessages();

          Toast.showToast("Message sent successfully!");
          return true;
        } else {
          Toast.showToast(
              responseBody?['message'] ?? "Failed to send message.");
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

  Future<void> fetchDirectChatMessages() async {
    try {
      Uri url = Uri.parse(
          'https://4waysproduction.co.za/mob_app/api/fetch_direct_chat.php');

      final response = await http.post(url, body: {
        "senderID": widget.data["senderID"],
        "receiverID": widget.data["receiverID"],
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
    fetchDirectChatMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RefreshIndicator(
            onRefresh: fetchDirectChatMessages,
            child: SingleChildScrollView(
              physics:
                  AlwaysScrollableScrollPhysics(), // to ensure that it's always scrollable
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
                        'Chat',
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
                print("wow");
                print(message['senderID'].toString());

                print(widget.data["senderID"]);

                var isOwnMessage =
                    message['senderID'].toString() == widget.data["senderID"];

                return ChatBubble(
                  isOwnMessage: isOwnMessage,
                  textMessage: message['message'],
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
