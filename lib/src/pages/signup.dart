import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:fourways/src/pages/login.dart';
import 'package:fourways/src/utils/toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'dart:io';

File? _image;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  bool isLoading = false;
//  http.Client httpClient = http.Client();

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

  Future<void> handleSignup() async {
    setState(() {
      isLoading = true;
    });
    final url =
        Uri.parse('https://4waysproduction.co.za/mob_app/api/signup.php');

    try {
      String filePath = imageController.text;

      if (filePath.startsWith("File: '") && filePath.endsWith("'")) {
        filePath = filePath.substring(7, filePath.length - 1);
      }

      var request = http.MultipartRequest('POST', url);

      request.files
          .add(await http.MultipartFile.fromPath('image_path', filePath));

      request.fields['name'] = nameController.text.toString();
      request.fields['surname'] = surnameController.text.toString();
      request.fields['email'] = emailController.text.toString();
      request.fields['password'] = passwordController.text.toString();

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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 120, 255),
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
      height: size.height * 0.8,
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
            height: size.height * 0.02,
          ),

          //email & password textField
          nameTextField(size),
          SizedBox(
            height: size.height * 0.01,
          ),
          surnameTextField(size),
          SizedBox(
            height: size.height * 0.01,
          ),
          emailTextField(size),
          SizedBox(
            height: size.height * 0.01,
          ),
          password(size),
          SizedBox(
            height: size.height * 0.01,
          ),
          // Add the image picker button
          imagePickerButton(),
          // Add this Text widget
          // Add this Text widget to display the selected image path
          Text(
            imageController.text.isEmpty
                ? 'No Image Selected'
                : imageController.text,
            style: GoogleFonts.inter(
              fontSize: 10.0,
              color: Colors.black,
            ),
          ),
          //sign in button
          SizedBox(
            height: 7,
          ),
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
                text: 'Already have an account? ',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'Login here',
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
                              LoginPage()), // Replace SignUpPage() with the actual name of your SignUp page class
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
          color: const Color(0xFF022F68),
          letterSpacing: 2.000000061035156,
        ),
        children: const [
          TextSpan(
            text: 'SIGN-UP',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget nameTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextFormField(
          controller: nameController,
          style: GoogleFonts.inter(
            fontSize: 13.0,
            color: const Color(0xFF151624),
          ),
          maxLines: 1,
          keyboardType: TextInputType.text,
          cursorColor: const Color(0xFF151624),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter your name',
            hintStyle: GoogleFonts.inter(
              fontSize: 13.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: nameController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            // Remove the border
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(
                color: Color.fromRGBO(44, 185, 176, 1),
              ),
            ),
            prefixIcon: Icon(
              Icons.person_2_rounded,
              color: nameController.text.isEmpty
                  ? const Color(0xFF151624).withOpacity(0.5)
                  : const Color.fromRGBO(44, 185, 176, 1),
              size: 16,
            ),
            suffix: Container(
              alignment: Alignment.center,
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: const Color.fromRGBO(44, 185, 176, 1),
              ),
              child: nameController.text.isEmpty
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

  Widget surnameTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextFormField(
          controller: surnameController,
          style: GoogleFonts.inter(
            fontSize: 13.0,
            color: const Color(0xFF151624),
          ),
          maxLines: 1,
          keyboardType: TextInputType.text,
          cursorColor: const Color(0xFF151624),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your surname';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter your surname',
            hintStyle: GoogleFonts.inter(
              fontSize: 13.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: surnameController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            // Remove the border
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(
                color: Color.fromRGBO(44, 185, 176, 1),
              ),
            ),
            prefixIcon: Icon(
              Icons.person_3_rounded,
              color: surnameController.text.isEmpty
                  ? const Color(0xFF151624).withOpacity(0.5)
                  : const Color.fromRGBO(44, 185, 176, 1),
              size: 13,
            ),
            suffix: Container(
              alignment: Alignment.center,
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: const Color.fromRGBO(44, 185, 176, 1),
              ),
              child: surnameController.text.isEmpty
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

  Widget emailTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextFormField(
          controller: emailController,
          style: GoogleFonts.inter(
            fontSize: 13.0,
            color: const Color(0xFF151624),
          ),
          cursorColor: const Color(0xFF151624),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: GoogleFonts.inter(
              fontSize: 13.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: emailController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            // Remove the border
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(
                color: Color.fromRGBO(44, 185, 176, 1),
              ),
            ),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: emailController.text.isEmpty
                  ? const Color(0xFF151624).withOpacity(0.5)
                  : const Color.fromRGBO(44, 185, 176, 1),
              size: 16,
            ),
            suffix: Container(
              alignment: Alignment.center,
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: const Color.fromRGBO(44, 185, 176, 1),
              ),
              child: emailController.text.isEmpty
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

  Widget password(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextFormField(
          controller: passwordController, // Use the passwordController here
          style: GoogleFonts.inter(
            fontSize: 13.0,
            color: const Color(0xFF151624),
          ),
          cursorColor: const Color(0xFF151624),
          obscureText: true,
          keyboardType:
              TextInputType.text, // Use TextInputType.text for a password field
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter your password.',
            hintStyle: GoogleFonts.inter(
              fontSize: 13.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: passwordController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            // Remove the border
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(
                color: Color.fromRGBO(44, 185, 176, 1),
              ),
            ),
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: passwordController.text.isEmpty
                  ? const Color(0xFF151624).withOpacity(0.5)
                  : const Color.fromRGBO(44, 185, 176, 1),
              size: 16,
            ),
            suffix: Container(
              alignment: Alignment.center,
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: const Color.fromRGBO(44, 185, 176, 1),
              ),
              child: passwordController.text.isEmpty
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

  Widget imagePickerButton() {
    return ElevatedButton(
      onPressed: () {
        _pickImage(); // Call the function when the button is pressed
      },
      child: Text('Add Profile Pic'),
    );
  }

  Widget signInButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (nameController.text.isEmpty ||
            surnameController.text.isEmpty ||
            emailController.text.isEmpty ||
            passwordController.text.isEmpty ||
            imageController.text.isEmpty) {
          // Display an error message or toast indicating that all fields are required.
          Toast.showToast('All fields are required');
          return;
        } else {
          // Call the handleSignup function when the button is pressed
          handleSignup();
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 41,
        width: size.width * 0.6,
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
                'Sign-Up',
                style: GoogleFonts.inter(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
