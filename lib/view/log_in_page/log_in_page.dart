import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etracker/base/app_constants.dart';
import 'package:etracker/view/signup_page/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:etracker/utils/mysize.dart';
import '../../base/credentials/google_sheets_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../../widgets/snackbar.dart';
import '../home_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _loggingIn = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;

  void _validate() {
    setState(() {
      _emailError = null;
      _passwordError = null;

      String email = _emailController.text.toLowerCase().trim();
      String password = _passwordController.text.trim();

      if (email.isEmpty) {
        _emailError = 'Email cannot be empty';
      } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
          .hasMatch(email)) {
        _emailError = 'Invalid email format';
      }

      if (password.isEmpty) {
        _passwordError = 'Password cannot be empty';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log In'.toUpperCase(),
          style: TextStyle(
              fontSize: MySize.size24,
              fontWeight: FontWeight.w600,
              letterSpacing: MySize.size5),
        ),
        leading: null,
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(MySize.size20),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MySize.size20,
                  ),
                  Image.asset(
                    AppConstants.logo,
                    height: MySize.size200,
                    width: MySize.size363,
                    fit: BoxFit.cover,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MySize.size40,
                      ),
                      Text(
                        'Email:',
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: MySize.size16,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: MySize.size4),
                      CustomTextField(
                          controller: _emailController,
                          hintText: 'Enter email',
                          errorText: _emailError,
                          isEmail: true),
                      SizedBox(height: MySize.size10),
                      Text(
                        'Password:',
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: MySize.size16,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: MySize.size4),
                      SizedBox(
                        height:_passwordError == null? MySize.scaleFactorHeight * 45: MySize.scaleFactorHeight *75,
                        child: CustomTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            errorText: _passwordError,
                            isPassword: true),
                      ),
                      SizedBox(
                        height: MySize.size5,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                            onTap: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  color: Colors.green.shade600,
                                  fontWeight: FontWeight.w500,
                                  fontSize: MySize.size18),
                            )),
                      ),
                      SizedBox(
                        height: MySize.size20,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        elevation: const MaterialStatePropertyAll(2),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(MySize.size10),
                            side: BorderSide(
                                color: Colors.grey.shade400, width: .5))),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.grey.shade100),
                        visualDensity: VisualDensity.compact),
                    onPressed: () {
                      _validate();
                      if (_emailError == null && _passwordError == null) {
                        _handleSignIn(context);
                      }
                    },
                    child: _loggingIn
                        ? Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: MySize.size5),
                            child: CircularProgressIndicator(
                              strokeWidth: MySize.size2,
                              color: Colors.grey.shade900,
                            ))
                        : Text(
                            'log in'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.green.shade500,
                                fontWeight: FontWeight.w600,
                                fontSize: MySize.size18),
                          ),
                  ),
                  SizedBox(
                    height: MySize.scaleFactorHeight * 80,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ));
                    },
                    child: RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: MySize.size14,
                            )),
                        TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade500)),
                      ],
                    )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Combine shared preferences check and Google Sheets API method

  // Add this method for sign-in
  void _handleSignIn(BuildContext context) async {
    String email = _emailController.text.toLowerCase().trim();
    String password = _passwordController.text.trim();
    setState(() {
      _loggingIn = true;
    });
    // Validate username
    if (email.isEmpty || password.isEmpty) {
      // Show an error message or handle validation as needed
      CustomSnackBar.show(
        message: 'Fill All the Fields ',
        isError: true, // Set to true for red color, false for green color
      );
      setState(() {
        _loggingIn = false;
      });
      return;
    }

    final sheetTitle = email;
    final isAvailable = await GoogleSheetsApi.isSheetAvailable(sheetTitle);
    if (isAvailable) {
      await _saveLoginState(
        email,
        password,
      );
      setState(() {
        _loggingIn = false;
      });
      //REPLACE THE CURRENT PAGE WITH THE HOMEPAGE IF USER'S DATA IS ALREADY STORED IN THE SHARED PREFFERENCES
    } else {
      setState(() {
        _loggingIn = false;
      });
      CustomSnackBar.show(
        message: 'user data not available check email again !',
        isError: true, // Set to true for red color, false for green color
      );
    }
  }
}

Future<void> _saveLoginState(
  String email,
  String password,
) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null) {
      // Fetch user data from Firestore
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Extract relevant data from the document
      String name = userData['name'] ??
          ""; // Update 'name' with the actual field name in your Firestore document
      String email = userData['email'] ??
          ""; // Update 'name' with the actual field name in your Firestore document
      String username = userData['username'] ??
          ""; // Update 'name' with the actual field name in your Firestore document
      String phoneNumber = userData['phoneNumber'] ??
          ""; // Update 'name' with the actual field name in your Firestore document

      // Save user data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('name', name);
      prefs.setString('email', email);
      prefs.setString('username', username);
      prefs.setString('phoneNumber', phoneNumber);

      // Show success notification
      CustomSnackBar.show(
        message: 'Logged in successfully!',
        isError: false, // Set to true for red color, false for green color
      );

      //REPLACE THE CURRENT PAGE WITH THE HOMEPAGE IF USER'S DATA IS ALREADY STORED IN THE SHARED PREFFERENCES
      Get.off(() => const HomePage());
    } else {
      // Handle the case where user is null
      return;
    }
  } catch (e) {
    // Show error notification
    CustomSnackBar.show(
      message: e.toString(),
      isError: true,
    );
    return;
  }
}

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool isEmail;
  final bool isNumber;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.isEmail = false,
    this.isNumber = false,
    this.errorText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool hidePassword = true;

  TextInputType getKeyboardType() {
    if (widget.isEmail) {
      return TextInputType.emailAddress;
    } else if (widget.isNumber) {
      return const TextInputType.numberWithOptions(signed: true);
    } else {
      return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorColor: Colors.green.shade600,
      cursorWidth: 1.5,
      autocorrect: true,
      textCapitalization: TextCapitalization.none,
      obscureText: hidePassword && widget.isPassword == true,
      keyboardType: getKeyboardType(),
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
              horizontal: MySize.size15, vertical: MySize.size10),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          errorText: widget.errorText,
          suffixIcon: widget.isPassword
              ? IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  icon: Icon(
                    hidePassword
                        ? CupertinoIcons.eye_slash
                        : Icons.remove_red_eye_outlined,
                    color: hidePassword ? Colors.grey.shade600 : Colors.green,
                    size: MySize.size22,
                  ),
                )
              : null,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green.shade700, width: 1.5),
            borderRadius: BorderRadius.circular(MySize.size10),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: .2),
            borderRadius: BorderRadius.circular(MySize.size10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: .1),
            borderRadius: BorderRadius.circular(MySize.size10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1),
            borderRadius: BorderRadius.circular(MySize.size10),
          ),
          fillColor: Colors.white,
          hoverColor: Colors.grey.shade200),
    );
  }
}
