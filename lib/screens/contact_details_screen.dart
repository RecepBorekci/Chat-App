import 'package:chat_app/screens/chat_screen_test.dart';
import 'package:chat_app/utility/user_data_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact_data.dart';
import '../utility/contact_data_notifier.dart';
import '../utility/database_helper.dart';
import '../theme.dart';
import '../utility/message_data_notifier.dart';
import '../widgets/avatar.dart';
import '../widgets/contact_widget_button.dart';
import '../widgets/icon_buttons.dart';

const contactCustomNameTextStyle = TextStyle(
  fontSize: 30,
  color: Colors.blue,
  fontWeight: FontWeight.bold,
);

const contactNameTextStyle = TextStyle(
  fontSize: 15.0,
);

class ContactDetailsScreen extends StatelessWidget {
  const ContactDetailsScreen({
    Key? key,
    required this.contactName,
    required this.contactPhoneNumber,
  }) : super(key: key);

  final String contactName;
  final String contactPhoneNumber;

  @override
  Widget build(BuildContext context) {
    final contactDataNotifier = context.watch<ContactDataNotifier>();
    final contact = contactDataNotifier.findContactByPhoneNumber(contactPhoneNumber);

    final signedInUser = context.watch<UserDataNotifier>().signedInUserData;

    final TextEditingController _contactNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 54,
        actionsIconTheme: Theme.of(context).iconTheme,
        leading: Align(
          alignment: Alignment.centerRight,
          child: IconBackground(
            icon: CupertinoIcons.back,
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Center(
              child: IconBorder(
                icon: Icons.edit,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Update Contact Name'),
                      content: TextField(
                        controller: _contactNameController,
                        decoration: InputDecoration(
                          labelText: 'New Name',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Get the new contact name from the text field
                            String newContactName = _contactNameController.text;
                            if (newContactName.isNotEmpty) {
                              // Get the current contact data
                              ContactData? currentContact =
                                  contactDataNotifier.currentContactData;

                              if (currentContact != null) {
                                // Call the updateContactName method
                                contactDataNotifier.updateContactName(
                                  currentContact,
                                  newContactName,
                                );
                              }

                              // Close the dialog
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('Update'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: IconBorder(
                icon: Icons.more_vert,
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Avatar(
                      radius: 100,
                      url: 'https://picsum.photos/200',
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      contactName,
                      style: contactCustomNameTextStyle,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      contact?.contactUser!.name ?? '',
                      style: contactNameTextStyle,
                    ),
                  ],
                ),
              ),
              Divider(
                color: AppColors.secondary,
                thickness: 3.0,
                indent: 15.0,
                endIndent: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ContactWidgetButton(
                      buttonIcon: Icon(Icons.call),
                      buttonName: 'Call',
                      buttonAction: () {},
                    ),
                    ContactWidgetButton(
                      buttonIcon: Icon(Icons.message),
                      buttonName: 'Message',
                      buttonAction: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {

                          context.read<MessageDataNotifier>().showAllMessages(signedInUser!.id, contact!.contactUser!.id);

                          return ChatScreenTest(signedInUserData: signedInUser, contactData: contact);
                        }));
                      },
                    ),
                    ContactWidgetButton(
                      buttonIcon: Icon(Icons.email),
                      buttonName: 'Email',
                      buttonAction: () {},
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 30.0,
                      bottom: 10,
                    ),
                    child: Text(
                      "More User Information",
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 0.3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(contact?.contactUser!.username ?? ''),
                    subtitle: Text('Username'),
                  ),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text(contact?.contactUser!.email ?? ''),
                    subtitle: Text('Email'),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text(contact?.contactUser!.phoneNumber ?? ''),
                    subtitle: Text('Phone Number'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
