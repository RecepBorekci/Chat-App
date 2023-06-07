import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../utility/database_helper.dart';

class MessagesPage extends StatelessWidget {
  MessagesPage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
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
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: senderController,
                                  decoration:
                                      InputDecoration(hintText: "Sender Email"),
                                ),
                              ),
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
                                  decoration:
                                      InputDecoration(hintText: "Message"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  child: Text("Send"),
                                  onPressed: () {
                                    sendMessage(
                                        senderController.text,
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
              child: Text("Go to Convarsation Page"))
        ],
      ),
    );
  }
}
