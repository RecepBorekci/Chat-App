import 'package:chat_app/utility/user_data_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import '../models/contact_data.dart';
import 'database_helper.dart';
import 'secrets.dart';

class ContactDataNotifier with ChangeNotifier {
  List<ContactData> _contacts = [];
  List<ContactData> get contacts => _contacts;

  UserDataNotifier userDataNotifier = UserDataNotifier();
  DatabaseHelper _databaseHelper = DatabaseHelper();

  // Future<void> loadContacts() async {
  //   // Load contacts from the database
  //   DatabaseHelper databaseHelper = DatabaseHelper();
  //   MySqlConnection? conn = await databaseHelper.createConnection();
  //
  //   if (conn != null) {
  //     try {
  //       int userId = _signedInUserData.id;
  //       Results results = await conn.query(
  //         'SELECT * FROM contacts WHERE user_id = ?',
  //         [userId],
  //       );
  //
  //       _contacts = results.map((row) {
  //         return ContactData(
  //           id: row['id'],
  //           userId: row['user_id'],
  //           contactUserId: row['contact_user_id'],
  //           contactName: row['contact_name'],
  //         );
  //       }).toList();
  //
  //       notifyListeners();
  //     } catch (e) {
  //       print('Error loading contacts: $e');
  //     } finally {
  //       await databaseHelper.removeConnection(conn);
  //     }
  //   }
  // }

  // Future<void> addNewContact(int contactUserId, String contactName) async {
  //   DatabaseHelper databaseHelper = DatabaseHelper();
  //   MySqlConnection? conn = await databaseHelper.createConnection();
  //
  //   if (conn != null) {
  //     try {
  //       int userId = userDataNotifier.signedInUserData.id;
  //
  //       await databaseHelper.addContact(conn, userId, contactUserId, contactName);
  //
  //       print('New contact added.');
  //       notifyListeners();
  //     } catch (e) {
  //       print('Error adding contact: $e');
  //     } finally {
  //       await databaseHelper.removeConnection(conn);
  //     }
  //   }
  // }

  Future<void> addNewContact(
      String signedInUsername, String phoneNumber, String contactName) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    MySqlConnection? conn = await databaseHelper.createConnection();

    if (conn != null) {
      try {
        await userDataNotifier.signInUser(signedInUsername);

        if (userDataNotifier.signedInUserData != null) {
          int userId = userDataNotifier.signedInUserData!.id;

          await databaseHelper.addContact(userId, contactName, phoneNumber);

          Results results = await databaseHelper.showContacts();

          // if (results.isNotEmpty) {
          //   List<ContactData> newData = results.map((row) => ContactData(
          //     id: row[0],
          //     userId: row[1],
          //     contactUserId: row[2],
          //     contactCustomName: row[3],
          //   )).toList();
          //
          //   _contacts.addAll(newData);
          //
          //   print('New contact added. Contact name is ' + contacts.first.contactCustomName);
          // }
        } else {
          print('Signed in user data is null.');
        }

        notifyListeners();
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> loadContacts(int? userId) async {
    try {
      List<ContactData> contacts = [];
      // Results rows = await _databaseHelper.joinUsersAndContacts(userId);
      Results rows = await _databaseHelper.showContacts();

      for (var row in rows) {
        Results contactRows = await _databaseHelper.findUsersById(row[2]);

        int i = 0;
        for (var contactRow in contactRows) {
          ContactData contact = ContactData(
              id: row[0],
              userId: row[1],
              contactUserId: row[2],
              contactCustomName: row[3],
              contactName: contactRow[1],
              contactUsername: contactRow[2],
              contactPhoneNumber: contactRow[3],
              contactImageURL: contactRow[6],
              contactLastUpdate: contactRow[7]);
          print('Contact information ${contactRow[i]}');
          i++;
          contacts.add(contact);
        }
      }

      _contacts = contacts;
      notifyListeners();
    } catch (e) {
      print('Error loading contacts: $e');
      // Handle the error appropriately (e.g., log the error, display an error message).
    }
  }
}
