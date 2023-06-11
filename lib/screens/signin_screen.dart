import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/signup_screen.dart';
import 'package:chat_app/utility/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../models/user_data.dart';
import '../utility/user_data_notifier.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({Key? key}) : super(key: key);

  UserDataNotifier userDataNotifier = UserDataNotifier();

  DatabaseHelper databaseHelper = DatabaseHelper();

  TextEditingController emailOrUsernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String emailOrUsername = '';

  String password = '';

  // Checks if the given String is an email or a username.
  bool isEmail(String emailOrUsername) {
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

    if (emailRegex.hasMatch(emailOrUsername)) {
      // Input matches the email format
      print('Input is an email');

      return true;
    } else {
      // Input is assumed to be a username
      print('Input is a username');

      return false;
    }
  }

  String getEmailOrUsername(BuildContext context) {
    return emailOrUsernameController.text;
  }

  String getPassword(BuildContext context) {
    return passwordController.text;
  }

  void signIn(BuildContext context) async {
    final userDataNotifier =
        Provider.of<UserDataNotifier>(context, listen: false);
    final emailOrUsername = getEmailOrUsername(context);
    final password = getPassword(context);

    // Assuming you have a method to check the sign-in credentials and retrieve user data
    bool isSignInSuccessful =
        await databaseHelper.checkSignInCredentials(emailOrUsername, password);

    if (isSignInSuccessful) {
      // Example of updating user data in UserDataNotifier
      userDataNotifier.signInUser(emailOrUsername);

      // Example of navigating to the home screen with the updated user data
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => HomeScreen(
                  emailOrUsername: emailOrUsername,
                )),
      );
    } else {
      // Handle sign-in failure
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Sign-in Failed'),
            content: Text('Incorrect email/username or password.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Improve the UI design.
    var allUserDatas = context.watch<UserDataNotifier>().allUserDatas;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: emailOrUsernameController,
                decoration: InputDecoration(
                  labelText: 'Email or Username',
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  emailOrUsername = value;
                },
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                autocorrect: false,
                decoration: InputDecoration(label: Text('Password')),
                onChanged: (value) {
                  password = value;
                },
              ),
              TextButton(
                child: Text('SIGN IN'),
                onPressed: () async {
                  if (emailOrUsernameController.text.isNotEmpty) {
                    if (passwordController.text.isNotEmpty) {
                      if (passwordController.text.length > 5) {
                        await context
                            .read<UserDataNotifier>()
                            .signInUser(emailOrUsername);

                        bool isEmailInput = isEmail(emailOrUsername);

                        for (var userData in allUserDatas) {
                          var username = userData.username;
                          var email = userData.email;
                          var DBpassword = userData.password;

                          if ((isEmailInput && emailOrUsername == email) ||
                              (!isEmailInput && emailOrUsername == username)) {
                            if (password == DBpassword) {
                              print('Sign in successful. Username: $username');
                              // TODO: Remove parameters and use ValueListenables instead. CHECKED ✅
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                        emailOrUsername: emailOrUsername,
                                      )));
                            } else {
                              print('Incorrect password. Try again.');
                            }
                            return; // Exit the loop since a match is found
                          }
                        }

                        // If the loop completes without finding a match, it means the email/username is incorrect
                        print('Incorrect email/username. Try again.');

                        // dynamic users;
                        // db.createConnection().then((conn) async {
                        //   // value is an email.
                        //   users = await db.findUsersByEmail(conn!, emailOrUsername);
                        //
                        //   for (var row in users) {
                        //     var name = row[1];
                        //     var username = row[2];
                        //     var email = row[4];
                        //
                        //     var DBpassword = row[5];
                        //
                        //     print(emailOrUsername);
                        //     print(email);
                        //     print(DBpassword);
                        //     print(password);
                        //
                        //
                        //     if (emailOrUsername == email && password == DBpassword) {
                        //       print('Email is correct. Signing in...' + row[2]);
                        //       // TODO: Remove parameters and use ValueListenables instead.
                        //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
                        //     } else {
                        //       print('Wrong email. Try again');
                        //     }
                        //   }
                        // });

                        // db.createConnection().then((conn) async {
                        //   // value is a username.
                        //   users = await db.findUsersByUsername(conn!, emailOrUsername);
                        //
                        //   for (var row in users) {
                        //
                        //     var name = row[1];
                        //     var username = row[2];
                        //     var email = row[4];
                        //     var DBpassword = row[5];
                        //
                        //     if (username == emailOrUsername  && DBpassword == password) {
                        //       print('Username is correct. Signing in...' + username);
                        //       // TODO: Remove parameters and use ValueListenables instead.
                        //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
                        //     } else {
                        //       print('Wrong username. Try again');
                        //     }
                        //   }
                        // });
                      }
                    }
                  }
                },
              ),
              Row(
                children: [
                  Text('Not have account?'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SignupScreen();
                        }));
                      },
                      child: Text('Sign up'))
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HomeScreen(
                      emailOrUsername: emailOrUsername,
                    );
                  }));
                },
                child: Text('Go to Main Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
