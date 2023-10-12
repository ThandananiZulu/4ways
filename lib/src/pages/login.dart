import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fourways/src/pages/home_screen.dart';
import 'package:fourways/src/pages/signup.dart';
import 'package:fourways/src/utils/functions.dart';
import 'package:fourways/src/utils/toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/data.dart';
import '../models/models.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  Map loginData = {"email": "", "password": ""};
  bool isLoading = false;
  setter(String emails) async {
    var sessionManager = SessionManager();
    await sessionManager.remove("username");
    await sessionManager.set("username", emails);
    await sessionManager.remove("name");
    await sessionManager.remove("surname");
    await sessionManager.remove("profile");
    await sessionManager.remove("userID");
     await sessionManager.remove("role");
    print("wow:${emails}");
    print("okay");
  }

  Future<void> loginUser() async {
    print("hhh"+loginData["email"]);

    setState(() {
      isLoading = true;
    });
    const apiUrl = 'https://4waysproduction.co.za/mob_app/api/login.php';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'email': loginData["email"],
        'password': loginData["password"],
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        setter(loginData["email"]);
        await fetchUser();
        List<Post> fetchAllPosts = await fetchPosts();
        List<Story> fetchAllStories = await fetchStories();
       
        var profileImage = await SessionManager().get("profile");
        var name = await SessionManager().get("username");
        var userID = await SessionManager().get("userID");
        setState(() {
          currentUser =
              User(userID: userID, name: name, imageUrl: profileImage);
          posts = fetchAllPosts;
          stories = fetchAllStories;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        setState(() {
          isLoading = false;
        });
      } else {
        // Show an error message to the user
        Toast.showToast(
          data['message'],
        );
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // Handle other status codes

      Toast.showToast(
        'Something went wrong',
      );
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  fetchUser() async {
    var email = loginData["email"];
    print(email.toString());
    try {
      Uri url;

      url =
          Uri.parse('https://4waysproduction.co.za/mob_app/api/fetch_user.php');
      final response = await http.post(url, body: {"email": email.toString()});

      if (response.statusCode == 200) {
        var r = json.decode(response.body);
        print(r);
        var sessionManager = SessionManager();

        await sessionManager.set("name", r["name"].toString());
        await sessionManager.set("surname", r["surname"].toString());
        await sessionManager.set("profile", r["profile_image_url"].toString());
        await sessionManager.set("userID", r["userID"].toString());
         await sessionManager.set("role", r["role"].toString());

        if (r['error'] == false) {
        } else {
          Toast.showToast(r['message']);
        }
      }
    } catch (error) {
      Toast.showToast("Something went wrong");
      print(error);
    }

    return [];
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
          id:postData['post_id'],
            user: postData['users_id'] == userID
                ? meUser
                : postUser, // Assuming you still want to use the same user for all posts
            caption: postData['content'],
            timeAgo: formattedTimeAgo,
            imageUrl: postData['post_image'],
            likes: postData['likes']??0,
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF0190EE),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              //bg design, we use 3 svg img
              Positioned(
                left: -26,
                top: 51.0,
                child: SvgPicture.string(
                  '<svg viewBox="-26.0 51.0 91.92 91.92" ><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -26.0, 96.96)" d="M 48.75 0 L 65 32.5 L 48.75 65 L 16.24999809265137 65 L 0 32.5 L 16.25000381469727 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -10.83, 105.24)" d="M 0 0 L 27.625 11.05000019073486 L 55.25 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, 16.51, 93.51)" d="M 0 37.04999923706055 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                  width: 91.92,
                  height: 91.92,
                ),
              ),
              Positioned(
                right: 43.0,
                top: -103,
                child: SvgPicture.string(
                  '<svg viewBox="63.0 -103.0 268.27 268.27" ><path transform="matrix(0.5, -0.866025, 0.866025, 0.5, 63.0, 67.08)" d="M 147.2896423339844 0 L 196.3861999511719 98.19309997558594 L 147.2896423339844 196.3861999511719 L 49.09654235839844 196.3861999511719 L 0 98.19309234619141 L 49.09656143188477 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.5, -0.866025, 0.866025, 0.5, 113.73, 79.36)" d="M 0 0 L 83.46413421630859 33.38565444946289 L 166.9282684326172 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.5, -0.866025, 0.866025, 0.5, 184.38, 23.77)" d="M 0 111.9401321411133 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                  width: 268.27,
                  height: 268.27,
                ),
              ),
              Positioned(
                right: -19,
                top: 31.0,
                child: SvgPicture.string(
                  '<svg viewBox="329.0 31.0 65.0 65.0" ><path transform="translate(329.0, 31.0)" d="M 48.75 0 L 65 32.5 L 48.75 65 L 16.24999809265137 65 L 0 32.5 L 16.25000381469727 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(333.88, 47.58)" d="M 0 0 L 27.625 11.05000019073486 L 55.25 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(361.5, 58.63)" d="M 0 37.04999923706055 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                  width: 65.0,
                  height: 65.0,
                ),
              ),

              //card and footer ui
              Positioned(
                bottom: 20.0,
                child: Column(
                  children: <Widget>[
                    buildCard(size),
                    buildFooter(size),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(Size size) {
    return Container(
      alignment: Alignment.center,
      width: size.width * 0.9,
      height: size.height * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //logo & text
          logo(size.height / 8, size.height / 8),
          SizedBox(
            height: size.height * 0.03,
          ),
          richText(24),
          SizedBox(
            height: size.height * 0.05,
          ),

          //email & password textField
          emailTextField(size),
          SizedBox(
            height: size.height * 0.02,
          ),
          passwordTextField(size),
          SizedBox(
            height: size.height * 0.03,
          ),

          //remember & forget text
          buildRememberForgetSection(),
          SizedBox(
            height: size.height * 0.04,
          ),

          //sign in button
          signInButton(size),
        ],
      ),
    );
  }

  Widget buildFooter(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          height: size.height * 0.04,
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Text.rich(
          TextSpan(
            style: GoogleFonts.inter(
              fontSize: 12.0,
              color: Colors.white,
            ),
            children: [
              TextSpan(
                text: 'Don’t have an account? ',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'Sign Up here',
                style: TextStyle(
                  color: Color(0xFFFE9879),
                  fontWeight: FontWeight.w500,
                ),
                // Add the onTap callback here
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Navigate to the SignUp page here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SignUp()), // Replace SignUpPage() with the actual name of your SignUp page class
                    );
                  },
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget logo(double height_, double width_) {
    return Image.asset(
      'assets/logo.png',
      height: height_,
      width: width_,
    );
  }

  Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: Color.fromRGBO(2, 47, 104, 1),
          letterSpacing: 2.000000061035156,
        ),
        children: const [
          TextSpan(
            text: 'LOGIN',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget emailTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          onChanged: (value) => loginData['email'] = value, // capture input
          style: GoogleFonts.inter(
            fontSize: 18.0,
            color: const Color(0xFF151624),
          ),
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          cursorColor: const Color(0xFF151624),
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: loginData['email'].isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: loginData['email'].isEmpty
                      ? Color.fromARGB(129, 0, 0, 0)
                      : const Color.fromRGBO(2, 47, 104, 1),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(2, 47, 104, 1),
                )),
            prefixIcon: Icon(
              Icons.mail_outline_rounded,
              color: loginData['email'].isEmpty
                  ? Color.fromRGBO(2, 47, 104, 1).withOpacity(0.5)
                  : const Color.fromRGBO(2, 47, 104, 1),
              size: 16,
            ),
            suffix: Container(
              alignment: Alignment.center,
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: const Color.fromRGBO(2, 47, 104, 1),
              ),
              child: loginData['email'].isEmpty
                  ? const Center()
                  : const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 13,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          onChanged: (value) => loginData['password'] = value, // capture input
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: const Color(0xFF151624),
          ),
          cursorColor: const Color(0xFF151624),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: loginData['password'].isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: loginData['password'].isEmpty
                      ? const Color.fromARGB(94, 0, 0, 0)
                      : const Color.fromRGBO(2, 47, 104, 1),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(2, 47, 104, 1),
                )),
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: loginData['password'].isEmpty
                  ? const Color(0xFF151624).withOpacity(0.5)
                  : const Color.fromRGBO(2, 47, 104, 1),
              size: 16,
            ),
            suffix: Container(
              alignment: Alignment.center,
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: const Color.fromRGBO(2, 47, 104, 1),
              ),
              child: loginData['password'].isEmpty
                  ? const Center()
                  : const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 13,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signInButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (loginData['email'].isEmpty || loginData['password'].isEmpty) {
          // Display an error message in a toast indicating that all fields are required.
          Toast.showToast('All fields are required');
          return;
        } else {
        
          loginUser();
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: size.height / 13,
        width: size.width * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: const Color(0xFF022F68),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4C2E84).withOpacity(0.2),
              offset: const Offset(0, 15.0),
              blurRadius: 60.0,
            ),
          ],
        ),
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                'Login',
                style: GoogleFonts.inter(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }

  Widget buildRememberForgetSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Color(0xFF022F68),
            ),
            child: const Icon(
              Icons.check,
              size: 13,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            'Remember me',
            style: GoogleFonts.inter(
              fontSize: 15.0,
              color: Color.fromRGBO(2, 47, 104, 1),
            ),
          ),
          const Spacer(),
          Text(
            'Forgot password',
            style: GoogleFonts.inter(
              fontSize: 13.0,
              color: Color.fromRGBO(2, 47, 104, 1),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
