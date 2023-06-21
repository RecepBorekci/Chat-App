import 'package:chat_app/pages/calls_page.dart';
import 'package:chat_app/pages/contacts_page.dart';
import 'package:chat_app/pages/messages_page.dart';
import 'package:chat_app/pages/notifications_page.dart';
import 'package:chat_app/utility/database_helper.dart';
import 'package:chat_app/utility/user_data_notifier.dart';
import 'package:chat_app/utility/database_helper.dart';
import 'package:chat_app/utility/user_data_notifier.dart';
import 'package:chat_app/widgets/glowing_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:provider/provider.dart';
import '../helpers.dart';
import '../models/user_data.dart';
import '../theme.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final ValueNotifier<int> pageIndex = ValueNotifier(0);
  final ValueNotifier<String> title = ValueNotifier("Messages");
  UserDataNotifier? userDataNotifier;

  final pages = const [
    MessagesPage(),
    NotificationsPage(),
    CallsPage(),
    ContactsPage(),
  ];

  final pageTitleList = const [
    "Messages",
    "Notifications",
    "Calls",
    "Contacts",
  ];

  void _onNavigationItemSelected(index) {
    title.value = pageTitleList[index];
    pageIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    var signedInUser = context.watch<UserDataNotifier>().signedInUserData;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ValueListenableBuilder(
          valueListenable: title,
          builder: (BuildContext context, String value, _) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: Text(
                    'Welcome ${signedInUser!.name}!',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // THE LINE ABOVE IS EQUAL TO THIS 20 LINES OF CODE, JUST SO YOU KNOW!!!
                // Consumer<UserDataNotifier>(
                //   builder: (context, userDataNotifier, _) {
                //     List<UserData> userDataList = userDataNotifier.allUserDatas;
                //
                //     // If no data is fetched. Show 'No user data available'.
                //     if (userDataList == null || userDataList.isEmpty) {
                //       return Text(
                //         'No user data available',
                //         style: TextStyle(color: Colors.black),
                //       );
                //     }
                //
                //     final userData = userDataList[0];
                //
                //     print('The username: ' + userData.username);
                //
                //     // Show simple welcome text with the fetched userData.
                //     return Text('Welcome ${userData.name}' + '!', style: TextStyle(color: Colors.black));
                //   },
                // ),
              ],
            );
          },
        ),
        leading: Align(
          alignment: Alignment.centerRight,
          child: IconBackground(
            icon: Icons.search_outlined,
            onTap: () {
              print("TODO search function");
            },
          ),
        ),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 25.0),
          //   child: Avatar.small(
          //     url:
          //         "https://talhakarakoyunlu.github.io/cv/images/talha%20profile%20picture.png",
          //   ),
          // ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: pageIndex,
        builder: (BuildContext context, int value, _) {
          return pages[value];
        },
      ),
      bottomNavigationBar:
          _BottomNavigationBar(onSelected: _onNavigationItemSelected),
    );
  }
}

class _BottomNavigationBar extends StatefulWidget {
  const _BottomNavigationBar({Key? key, required this.onSelected})
      : super(key: key);

  final ValueChanged<int> onSelected;

  @override
  State<_BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<_BottomNavigationBar> {
  var selectedIndex = 0;
  void handleItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Card(
      color: (brightness == Brightness.light) ? Colors.transparent : null,
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 8,
            right: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavigationBarItem(
                label: "Message",
                icon: CupertinoIcons.bubble_left_bubble_right_fill,
                index: 0,
                onTap: handleItemSelected,
                isSelected: (selectedIndex == 0),
              ),
              _NavigationBarItem(
                label: "Notifications",
                icon: CupertinoIcons.bell_fill,
                index: 1,
                onTap: handleItemSelected,
                isSelected: (selectedIndex == 1),
              ),
              // Causes to overflow in the screen
              // Padding(
              //   padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
              //   child: GlowingActionButton(
              //     color: AppColors.secondary,
              //     icon: CupertinoIcons.add,
              //     onPressed: () {
              //       print("TODO on new message");
              //     },
              //   ),
              // ),
              _NavigationBarItem(
                label: "Calls",
                icon: CupertinoIcons.phone_fill,
                index: 2,
                onTap: handleItemSelected,
                isSelected: (selectedIndex == 2),
              ),
              _NavigationBarItem(
                label: "Contacts",
                icon: CupertinoIcons.person_2_fill,
                index: 3,
                onTap: handleItemSelected,
                isSelected: (selectedIndex == 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  const _NavigationBarItem({
    Key? key,
    required this.label,
    required this.icon,
    required this.index,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  final int index;
  final String label;
  final IconData icon;
  final ValueChanged<int> onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(index);
      },
      child: SizedBox(
        width: 70,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: isSelected ? 26 : 20,
                color: isSelected ? AppColors.secondary : null,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                label,
                style: isSelected
                    ? const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold)
                    : const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
