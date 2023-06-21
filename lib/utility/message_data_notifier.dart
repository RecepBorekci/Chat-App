import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mysql1/mysql1.dart';
import '../models/contact_data.dart';
import 'package:chat_app/models/message_data_2.dart';

import 'database_helper.dart';

class MessageDataNotifier with ChangeNotifier {

  final _messageController = StreamController<List<MessageData2>>.broadcast();

  List<MessageData2> _messages = [];
  List<MessageData2> get messages => _messages;

  DatabaseHelper _databaseHelper = DatabaseHelper();
  Stream<List<MessageData2>> get messageStream => _messageController.stream;

  MessageDataNotifier() {
    // Initialize the stream with the current state of _messages
    _messageController.add(List<MessageData2>.from(_messages));
  }

  Future<void> addNewMessage(String message, int senderId, int receiverId, String status) async {
    try {
      Results messageRows = await _databaseHelper.sendMessage(message, senderId, receiverId, status);

      late MessageData2 newMessage;

      for (var row in messageRows) {
        newMessage = MessageData2(
            id: row[0],
            message: row[1],
            sender_id: row[2],
            reciever_id: row[3],
            created_at: row[4],
            status: row[5]
        );
      }

      print(newMessage.message);
      print(newMessage.created_at);

      _messages.add(newMessage);
      _messageController.add(List<MessageData2>.from(_messages)); // Update the stream with the modified _messages list
      notifyListeners();

    } catch (e) {
      print('Error adding a new message: $e');
    }
  }


  Future<void> showAllMessages(int senderId, int receiverId) async {
    try {
      Results senderMessageRows = await _databaseHelper.showMessages(senderId, receiverId);
      Results receiverMessageRows = await _databaseHelper.showMessages(receiverId, senderId);

      List<MessageData2> allMessages = [];
      late MessageData2 message;

      for (var row in senderMessageRows) {
        message = MessageData2(
            id: row[0],
            message: row[1],
            sender_id: row[2],
            reciever_id: row[3],
            created_at: row[4],
            status: row[5]
        );
        allMessages.add(message);
      }

      for (var row in receiverMessageRows) {
        message = MessageData2(
            id: row[0],
            message: row[1],
            sender_id: row[2],
            reciever_id: row[3],
            created_at: row[4],
            status: row[5]
        );
        allMessages.add(message);
      }

      // Sort the messages by the created_at field in ascending order
      allMessages.sort((a, b) => a.created_at.compareTo(b.created_at));

      _messages = allMessages;
      _messageController.add(List<MessageData2>.from(_messages)); // Update the stream with the retrieved messages
      notifyListeners();

    } catch (e) {
      print('Error displaying messages: $e');
    }
  }

  // Method to receive a new message
  void receiveNewMessage() {
    _messageController.add(List<MessageData2>.from(_messages)); // Update the stream with the new message
  }

}