import 'package:flutter/material.dart';

import '../screens/contact_details_screen.dart';
import '../screens/conversation.dart';
import 'avatar.dart';

const contactsTextStyle = TextStyle(
  overflow: TextOverflow.ellipsis,
  fontSize: 18,
  letterSpacing: 0.3,
  wordSpacing: 1.7,
  fontWeight: FontWeight.w500,
);

class ContactWidget extends StatelessWidget {
  const ContactWidget(
      {Key? key,
      required this.imageURL,
      required this.contactCustomName,
      required this.contactPhoneNumber})
      : super(key: key);

  final String imageURL;
  final String contactCustomName;
  final String contactPhoneNumber;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ContactDetailsScreen(contactName: contactCustomName, contactPhoneNumber: contactPhoneNumber,);
        }));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Avatar.small(
              url: imageURL,
            ),
            Column(
              children: [
                Text(
                  contactCustomName,
                  style: contactsTextStyle,
                ),
                Text(
                  contactPhoneNumber,
                  style: contactsTextStyle,
                )
              ],
            ),
            IconButton(
                onPressed: () {
                  //TODO: Implement messaging.
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ConversationPage(theme: "light");
                  }));
                },
                icon: Icon(
                  Icons.message,
                  size: 20,
                  color: Colors.black54,
                )),
          ],
        ),
      ),
    );
  }
}
