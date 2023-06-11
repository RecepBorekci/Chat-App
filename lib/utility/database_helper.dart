import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'secrets.dart';

// TODO: Add CRUD methods for messages table and the future tables.
class DatabaseHelper {
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

  // Open a connection
  Future<MySqlConnection?> createConnection() async {
    MySqlConnection? conn;
    try {
      conn = await MySqlConnection.connect(
        ConnectionSettings(
            host: host, port: 3306, user: user, db: db, password: password),
      );
    } catch (e) {
      print('Connection failed');
      print(e);
    }
    return conn;
  }

  // USERS TABLE
  // Inserts a new user to Users table with the given parameters.
  Future<Results> insertUser(
      MySqlConnection conn,
      String name,
      String username,
      String phoneNumber,
      String email,
      String password,
      String? profilePictureURL) async {
    Results result;

    result = await conn.query(
        'insert into users (name, username, phoneNumber, email, password) values (?, ?, ?, ?, ?)',
        [name, username, phoneNumber, email, password]);
    print('Inserted row id=${result.insertId}');

    return result;
  }

  // Shows all users after inserting new data.
  Future<dynamic> showUsers(MySqlConnection conn, Results result) async {
    var results = await conn
        .query('select name, email from users where id = ?', [result.insertId]);
    for (var row in results) {
      print('name: ${row[0]}, email: ${row[1]}');
    }

    await removeConnection(conn);

    return results;
  }

  Future<dynamic> insertUserAndShowUsers(
      MySqlConnection conn,
      String name,
      String username,
      String phoneNumber,
      String email,
      String password,
      String? profilePictureURL) async {
    Results result;

    try {
      result = await conn.query(
        'insert into users (name, username, phoneNumber, email, password) values (?, ?, ?, ?, ?)',
        [name, username, phoneNumber, email, password],
      );
      print('Inserted row id=${result.insertId}');
    } catch (e) {
      print('Error inserting user: $e');
      await removeConnection(conn);
      return [];
    }

    var results = await conn.query(
      'select * from users where id = ?',
      [result.insertId],
    );

    for (var row in results) {
      print('name: ${row[0]}, email: ${row[1]}');
    }

    return results;
  }

  Future<dynamic> findUsersById(int id) async {
    MySqlConnection? conn = await createConnection();

    try {
      var results = await conn!.query('select * from users where id = ?', [id]);
      for (var row in results) {
        print(
            'id: ${row[0]}, name: ${row[1]}, username: ${row[2]}, phoneNumber: ${row[3]}, email: ${row[4]}, password: ${row[5]}, profile_picture_url: ${row[6]}, last_update: ${row[7]}');
      }

      return results;
    } catch (e) {
      print('Error checking sign-in credentials: $e');
    } finally {
      await removeConnection(conn);
    }
  }

  //TODO: Add findByPhoneNumber() method.
  Future<dynamic> findUsersByPhoneNumber(String phoneNumber) async {
    MySqlConnection? conn = await createConnection();

    try {
      var results = await conn!
          .query('select * from users where phoneNumber = ?', [phoneNumber]);
      for (var row in results) {
        print(
            'id: ${row[0]}, name: ${row[1]}, username: ${row[2]}, phoneNumber: ${row[3]}, email: ${row[4]}, password: ${row[5]}, profile_picture_url: ${row[6]}, last_update: ${row[7]}');
      }

      return results;
    } catch (e) {
      print('Error checking sign-in credentials: $e');
    } finally {
      await removeConnection(conn);
    }
  }

  // Shows all columns of data for the user with the given username
  Future<dynamic> findUsersByUsername(String username) async {
    MySqlConnection? conn = await createConnection();

    try {
      var results = await conn!
          .query('select * from users where username = ?', [username]);
      for (var row in results) {
        print(
            'id: ${row[0]}, name: ${row[1]}, username: ${row[2]}, phoneNumber: ${row[3]}, email: ${row[4]}, password: ${row[5]}, profile_picture_url: ${row[6]}, last_update: ${row[7]}');
      }

      return results;
    } catch (e) {
      print('Error checking sign-in credentials: $e');
    } finally {
      await removeConnection(conn);
    }
  }

  Future<dynamic> findUsersByEmail(String email) async {
    MySqlConnection? conn = await createConnection();

    try {
      var results =
          await conn!.query('select * from users where email = ?', [email]);
      for (var row in results) {
        print(
            'id: ${row[0]}, name: ${row[1]}, username: ${row[2]}, phoneNumber: ${row[3]}, email: ${row[4]}, password: ${row[5]}, profile_picture_url: ${row[6]}, last_update: ${row[7]}');
      }

      return results;
    } catch (e) {
      print('Error checking sign-in credentials: $e');
    } finally {
      await removeConnection(conn);
    }
  }

  // TODO: Add update methods.

  // Updates user email
  Future<void> updateUserEmail(String newEmail, oldEmail) async {
    MySqlConnection? conn = await createConnection();

    if (conn != null) {
      await conn.query(
          'update users set email=? where email=?', [newEmail, oldEmail]);
    }

    await removeConnection(conn);
  }

  // Updates user password
  Future<void> updateUserPassword(String newPassword, oldPassword) async {
    MySqlConnection? conn = await createConnection();

    if (conn != null) {
      await conn.query('update users set password=? where password=?',
          [newPassword, oldPassword]);
    }

    await removeConnection(conn);
  }

  // Deletes the user with the given password.
  Future<void> deleteUser(String password) async {
    MySqlConnection? conn = await createConnection();

    if (conn != null) {
      await conn.query('delete from users where password=?', [password]);
    }

    await removeConnection(conn);
  }

  Future<bool> checkSignInCredentials(
      String emailOrUsername, String password) async {
    MySqlConnection? conn = await createConnection();

    if (conn != null) {
      try {
        Results results;
        if (isEmail(emailOrUsername)) {
          // Input is email.
          results = await findUsersByEmail(emailOrUsername);
        } else {
          // Input is username.
          results = await findUsersByUsername(emailOrUsername);
        }

        if (results.isNotEmpty) {
          // User with the given email/username exists
          for (var row in results) {
            if (row[5] == password) {
              // Password matches
              return true;
            }
          }
        }
      } catch (e) {
        print('Error checking sign-in credentials: $e');
      } finally {
        await removeConnection(conn);
      }
    }

    return false; // Sign-in failed
  }

  // CONTACTS TABLE
  Future<void> addContact(
      int userId, String contactName, String contactPhoneNumber) async {
    MySqlConnection? conn = await createConnection();

    try {
      Results contactResults = await findUsersByPhoneNumber(contactPhoneNumber);

      if (contactResults != null && contactResults.isNotEmpty) {
        var contactUserId =
            contactResults.first[0].toString(); // Convert to String

        print('This is the contact user id: $contactUserId');

        await conn!.query(
          'INSERT INTO contacts (user_id, contact_user_id, contact_name) VALUES (?, ?, ?)',
          [userId, contactUserId, contactName],
        );

        print('Contact added successfully.');
      } else {
        print('No user found with the provided phone number.');
      }
    } catch (e) {
      print('Error adding contact: $e');
      // Handle the error appropriately (e.g., log the error, display an error message).
    } finally {
      await removeConnection(conn);
    }
  }

  Future<dynamic> showContacts() async {
    MySqlConnection? conn = await createConnection();

    try {
      Results results = await conn!.query('SELECT * FROM contacts');

      return results;
    } catch (e) {
      print('Error showing contacts: $e');
      // Handle the error appropriately (e.g., log the error, display an error message).
    } finally {
      removeConnection(conn);
    }
  }

  Future<dynamic> joinUsersAndContacts(int? userId) async {
    MySqlConnection? conn = await createConnection();

    try {
      Results results = await conn!.query(
          'SELECT * FROM users JOIN contacts ON ${userId} = contacts.user_id');

      for (var row in results) {
        print('Row 1: ${row[2]}');
      }

      return results;
    } catch (e) {
      print('Error joining tables: $e');
      // Handle the error appropriately (e.g., log the error, display an error message).
    } finally {
      removeConnection(conn);
    }
  }

  // Closes the connection.
  Future<void> removeConnection(MySqlConnection? conn) async {
    // Close the connection

    if (conn != null) {
      await conn.close();
    }
  }

  //TODO: CONVERSATION DATABASE (not a todo)
  Future<Results> sendMessage(
    MySqlConnection conn,
    String senderMail,
    String receiverMail,
    String message,
    String date,
    bool isRead,
  ) async {
    Results result;
    result = await conn.query(
        'insert into messages (senderMail, receiverMail, message, date, isRead) values (?, ?, ?, ?, ?)',
        [senderMail, receiverMail, message, date, isRead]);
    print('Inserted row id=${result.insertId}');
    return result;
  }

  Future<dynamic> showMessages(MySqlConnection conn, String senderMail) async {
    var results = await conn
        .query('select * from messages where senderMail = ?', [senderMail]);
    for (var row in results) {
      print(
          'id: ${row[0]}, senderMail: ${row[1]}, receiverMail: ${row[2]}, message: ${row[3]}, date: ${row[4]}, isRead: ${row[5]}');
    }

    return results;
  }
}
