import 'package:chat_app/screens/signup_screen.dart';
import 'package:chat_app/screens/test_screen.dart';
import 'package:chat_app/utility/contact_data_notifier.dart';
import 'package:chat_app/utility/message_data_notifier.dart';
import 'package:chat_app/utility/user_data_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'utility/database_helper.dart';
import 'screens/conversation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserDataNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => ContactDataNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => MessageDataNotifier(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  var theme = "light";
  var db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tema moment",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode
          .dark, // TEMAYI DEĞİŞTİRMEK İÇİN BUNU "ThemeMode.light" YA DA "ThemeMode.dark" YAP
      debugShowCheckedModeBanner: false,
      home: const SignupScreen(),
      ////////////////////////////////////////////// USE THESE FOR NAVIGATING ///////////////////////////////////////////////////
      routes: {
        "/conversation": (context) => ConversationPage(
              theme: "light",
            ),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, "/conversation"),
          child: Text("Tap Me!"),
        ),
      ),
    );
  }
}
