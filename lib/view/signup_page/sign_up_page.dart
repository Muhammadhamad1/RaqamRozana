import 'package:etracker/base/app_constants.dart';
import 'package:etracker/view/log_in_page/log_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:etracker/utils/mysize.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../../base/credentials/Register/register_user.dart';
import '../../widgets/snackbar.dart';

class SignUpPage extends StatefulWidget {

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _signingUp = false;
  bool _validated = false;
  bool _validated1 = false;

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController = TextEditingController();

   String? _nameError;
  String? _usernameError;
  String? _emailError;
  String? _phoneError ;
  String? _passwordError ;
  String? _confirmPasswordError ;

  void _validate() {
    setState(() {
      _nameError = null;
      _usernameError = null;
      _emailError = null;
      _phoneError = null;
      _passwordError = null;
      _confirmPasswordError = null;

      String name = _nameController.text.trim();
      String username = _usernameController.text.toLowerCase().trim();
      String email = _emailController.text.toLowerCase().trim();
      String phoneNumber = _phoneController.text.trim();
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (name.isEmpty) {
        _nameError = 'Name cannot be empty';
      }

      if (username.isEmpty) {
        _usernameError = 'Username cannot be empty';
      }

      if (email.isEmpty) {
        _emailError = 'Email cannot be empty';
      } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
          .hasMatch(email)) {
        _emailError = 'Invalid email format';
      }

      if (phoneNumber.isEmpty) {
        _phoneError = 'Phone Number cannot be empty';
        setState(() {
          _validated = false;
        });
      }

      if (password.isEmpty) {
        _passwordError = 'Password cannot be empty';
        setState(() {
          _validated = true;
        });
      }

      if (confirmPassword.isEmpty) {
        _confirmPasswordError = 'Confirm Password cannot be empty';
      } else if (confirmPassword != password) {
        _confirmPasswordError = 'Passwords do not match';
        setState(() {
          _validated1 = true;

        });


      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Sign up'.toUpperCase(),style: TextStyle(fontSize: MySize.size24,fontWeight: FontWeight.w600,letterSpacing: MySize.size5),),
        leading: null,
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MySize.size20,vertical: MySize.size6),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppConstants.logo,height: MySize.size200,width: MySize.size300,fit: BoxFit.cover,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name:',style: TextStyle(color: Colors.grey.shade700,fontSize: MySize.size16,fontWeight: FontWeight.w500),),
                      CustomTextField(controller: _nameController, hintText: 'Full Name',errorText: _nameError,),
                      SizedBox(height: MySize.size10),
                      Text('Username:',style: TextStyle(color: Colors.grey.shade700,fontSize: MySize.size16,fontWeight: FontWeight.w500),),
                      CustomTextField(controller: _usernameController, hintText: 'Username',errorText: _usernameError,),
                      SizedBox(height: MySize.size10),
                      Text('Email:',style: TextStyle(color: Colors.grey.shade700,fontSize: MySize.size16,fontWeight: FontWeight.w500),),
                      CustomTextField(controller: _emailController, hintText: 'Enter Email',isEmail: true,errorText: _emailError,),
                      SizedBox(height: MySize.size10),
                      Text('Password:',style: TextStyle(color: Colors.grey.shade700,fontSize: MySize.size16,fontWeight: FontWeight.w500),),
                      SizedBox(
                          height:_validated? MySize.scaleFactorHeight *75:  MySize.scaleFactorHeight *45,
                          child: CustomTextField(controller: _passwordController, hintText: 'Password', isPassword: true,errorText: _passwordError,)),
                      SizedBox(height: MySize.size10),
                      Text('Confirm Password:',style: TextStyle(color: Colors.grey.shade700,fontSize: MySize.size16,fontWeight: FontWeight.w500),),
                      SizedBox(
                          height:_validated1? MySize.scaleFactorHeight *75:  MySize.scaleFactorHeight *45,
                          child: CustomTextField(controller: _confirmPasswordController, hintText: 'Confirm Password', isPassword: true,errorText: _confirmPasswordError,)),
                      SizedBox(height: MySize.size10,),
                      Text('Phone Number:',style: TextStyle(color: Colors.grey.shade700,fontSize: MySize.size16,fontWeight: FontWeight.w500),),
                      CustomTextField(controller: _phoneController, hintText: 'Phone Number:',isNumber: true,errorText: _phoneError,),
                      SizedBox(height: MySize.size20,),
                    ],
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        elevation: const MaterialStatePropertyAll(2),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(MySize.size10),side: BorderSide(color: Colors.grey.shade400,width: .5))),
                        backgroundColor: MaterialStatePropertyAll(Colors.grey.shade100),visualDensity: VisualDensity.compact),
                    onPressed: () {
                      _validate();
                      if (_emailError == null && _passwordError == null) {
                        _handleSignUp(context);
                      }
                    },
                    child: _signingUp
                        ?  Padding(
                        padding: EdgeInsets.symmetric(vertical: MySize.size5),
                        child: CircularProgressIndicator(strokeWidth: MySize.size2,color: Colors.grey.shade900,))
                        :Text('Sign Up'.toUpperCase(),style: TextStyle(color: Colors.green.shade500,fontWeight: FontWeight.w600,fontSize: MySize.size18),),
                  ),
                  SizedBox(height: MySize.scaleFactorHeight * 50,),

                  GestureDetector(
                    onTap: () {
                      Get.off(() => const LogInPage());
                    },
                    child: RichText(text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an Account? ',
                          style: TextStyle(color: Colors.grey,fontSize: MySize.size16,)
                        ),
                        TextSpan(
                          text: 'Log In',
                          style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w600, color: Colors.green.shade500)
                        ),
                      ]
                    )),
                  ),
                  SizedBox(height: MySize.size20,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignUp(BuildContext context) async {
    String name = _nameController.text.trim();
    String username = _usernameController.text.toLowerCase().trim();
    String email = _emailController.text.toLowerCase().trim();
    String phoneNumber = _phoneController.text.trim();
    String password = _passwordController.text.trim();

    setState(() {
      _signingUp = true;
    });
    // Validate fields (add more validation as needed)
    if (username.isEmpty || email.isEmpty || phoneNumber.isEmpty || password.isEmpty) {
      // Show an error message or handle validation as needed
      CustomSnackBar.show(
        message: 'Please fill in all fields',
        isError: true, // Set to true for red color, false for green color
      );
      setState(() {
        _signingUp = false;
      });
      return;

    }

    // Save user data to SharedPreferences
    try {
      // Create user in Firebase Authentication
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      // Save additional user data to Cloud Fire-store
     await saveUserData(name,username,email,phoneNumber);
      CustomSnackBar.show(
        message: 'Account Successfully Registered.',
        isError: false, // Set to true for red color, false for green color
      );

      // Create a new sheet for the user (you can do this if needed),
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('name', name);
      prefs.setString('username', username);
      prefs.setString('email', email);
      prefs.setString('phoneNumber', phoneNumber);
      prefs.setString('password', password);
      CustomSnackBar.show(
        message: 'Finalizing Setup',
        isError: false, // Set to true for red color, false for green color
      );
      await GoogleSheetsRegister.setupUserSheet(email);
      setState(() {
        _signingUp = true;
      });

      // Navigate to the home page with the provided username
      Get.off(const LogInPage());
    } catch (error) {
      // Handle errors, e.g., show a SnackBar or print the error message
      CustomSnackBar.show(
        message: 'Could Not Setup Account Try Again.',
        isError: true, // Set to true for red color, false for green color
      );
      setState(() {
        _signingUp = false;
      });
    }
  }

  Future<void> saveUserData(String name, String username, String email, String phoneNumber) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Use the UID as the document ID
        String userId = user.uid;

        // Reference to the "users" collection and the specific document for the user
        DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

        // Set the data for the user
        await userDocRef.set({
          'name': name,
          'username': username,
          'email': email,
          'phoneNumber': phoneNumber,
          // Add more fields as needed
        });

      } else {
      }
    } catch (error) {
      CustomSnackBar.show(
        message: 'Error: Try Again. ',
        isError: true, // Set to true for red color, false for green color
      );
    }
  }
}