import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/signin_screen.dart';
import 'package:chat_app/utility/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_data.dart';
import '../utility/user_data_notifier.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Initialize all necessary variables.
  DatabaseHelper db = DatabaseHelper();

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();

  String name = 'No-name';
  String username = '';
  String phoneNumber = '';
  String email = '';
  String password = '';
  String retypePassword = '';

  @override
  Widget build(BuildContext context) {
    // TODO: Improve the UI design.

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 250,
          // Column of TextField and Buttons.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                autocorrect: true,
                decoration: InputDecoration(label: Text('Name')),
              ),
              TextField(
                controller: usernameController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                decoration: InputDecoration(label: Text('Username')),
              ),
              TextField(
                controller: phoneNumberController,
                keyboardType: TextInputType.number,
                autocorrect: true,
                decoration: InputDecoration(label: Text('Phone number')),
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: InputDecoration(label: Text('Email')),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                autocorrect: false,
                decoration: InputDecoration(label: Text('Password')),
              ),
              TextField(
                controller: retypePasswordController,
                obscureText: true,
                autocorrect: false,
                decoration: InputDecoration(label: Text('Retype Password')),
              ),
              TextButton(
                onPressed: () async {
                  // Nested if loops check that required boxes are filled before authentication.
                  if (usernameController.text.isNotEmpty) {
                    if (phoneNumberController.text.isNotEmpty &&
                        emailController.text.isNotEmpty) {
                      if (passwordController.text.isNotEmpty &&
                          retypePasswordController.text.isNotEmpty &&
                          passwordController.text.length > 5) {
                        name = nameController.text;
                        username = usernameController.text;
                        phoneNumber = phoneNumberController.text.trim();
                        email = emailController.text;
                        password = passwordController.text;
                        retypePassword = retypePasswordController.text;

                        // Prints username to check if that works.
                        print(username);

                        // If all conditions met, add the user to the database and go the main screen.
                        if (password == retypePassword) {
                          var userDataNotifier = Provider.of<UserDataNotifier>(
                              context,
                              listen: false);
                          await userDataNotifier.createUserData(name, username,
                              phoneNumber, email, password, null);

                          print('Sign up successful. Username: $username');

                          // TODO: Remove parameters and use ValueListenables instead. CHECKED ✅
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                    emailOrUsername: email,
                                  )));
                        } else {
                          print('Passwords do not match');
                        }
                      } else {
                        print('Password must be at least 6 characters long');
                      }
                    } else {
                      print('Phone number and email are required');
                    }
                  } else {
                    print('Username is required');
                  }
                },
                child: Text('SIGN UP'),
              ),
              Row(
                children: [
                  Text('Already have account?'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SigninScreen();
                        }));
                      },
                      child: Text('Log in'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
