import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../utility/database_helper.dart';
import 'dart:convert';

class MessagesPage extends StatefulWidget {
  final emailOrUsername;
  MessagesPage({Key? key, required this.emailOrUsername}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  // @override
  // void initState() {
  //   getEmail().then((value) => {
  //         setState(() {
  //           widget.email = value;
  //         })
  //       });
  //   super.initState();
  // }

  final receiverController = TextEditingController();

  final senderController = TextEditingController();

  final messageController = TextEditingController();

  DatabaseHelper database = DatabaseHelper();

  void sendMessage(String senderMail, String receiverMail, String message,
      String date, bool isRead) async {
    await database.sendMessage(
        await database.createConnection() as MySqlConnection,
        senderMail,
        receiverMail,
        message,
        date,
        isRead);
  }

  void showMessages(String senderMail) async {
    print(await database.showMessages(
        await database.createConnection() as MySqlConnection, senderMail));
  }

  Future<String> getEmail() async {
    String currentUserEmail;
    currentUserEmail = database.isEmail(widget.emailOrUsername)
        ? widget.emailOrUsername
        : await database
            .findUsersByUsername(widget.emailOrUsername)
            .then((value) {
            String jsonString = value
                    .toString()
                    .replaceAll('(Fields: ', '')
                    .replaceAll('})', '}')
                    .replaceAll('}', '')
                    .replaceAll('{', '"')
                    .replaceAll(', ', '", "')
                    .replaceAll(',}', '"}')
                    .replaceAll(': ', '": "') +
                '"';
            dynamic json = jsonDecode('{$jsonString}');
            String email = json['email'];
            currentUserEmail = email;
            return currentUserEmail;
          });
    return currentUserEmail;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getEmail(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the future to complete, show a loading indicator
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If an error occurred while fetching the data, show an error message
          return Text('Error: ${snapshot.error}');
        } else {
          // If the future completed successfully, display the fetched data
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("MessagesPage"),
                FloatingActionButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Form(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    // Padding(
                                    //   padding: EdgeInsets.all(8.0),
                                    //   child: TextFormField(
                                    //     controller: senderController,
                                    //     decoration: InputDecoration(
                                    //         hintText: "Sender Email"),
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: receiverController,
                                        decoration: InputDecoration(
                                            hintText: "Receiver Email"),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: messageController,
                                        decoration: InputDecoration(
                                            hintText: "Message"),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        child: Text(
                                            "${snapshot.data.toString()}"), //TODO: CHANGE IT TO SEND
                                        onPressed: () {
                                          sendMessage(
                                              snapshot.data.toString(),
                                              receiverController.text,
                                              messageController.text,
                                              DateTime.now().toString(),
                                              false);
                                          showMessages(senderController.text);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Icon(Icons.message),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/conversation");
                    },
                    child: Text("Go to Convarsation Page")),
              ],
            ),
          );
        }
      },
    );
  }
}
