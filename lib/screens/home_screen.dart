import 'package:chat_app/pages/calls_page.dart';
import 'package:chat_app/pages/contacts_page.dart';
import 'package:chat_app/pages/messages_page.dart';
import 'package:chat_app/pages/notifications_page.dart';
import 'package:chat_app/utility/database_helper.dart';
import 'package:chat_app/utility/user_data_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../helpers.dart';
import '../models/user_data.dart';
import '../theme.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  final String emailOrUsername;
  HomeScreen({Key? key, required this.emailOrUsername}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> pageIndex = ValueNotifier(0);

  final ValueNotifier<String> title = ValueNotifier("Messages");

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
    final pages = [
      MessagesPage(
        emailOrUsername: widget.emailOrUsername,
      ),
      NotificationsPage(),
      CallsPage(),
      ContactsPage(),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ValueListenableBuilder(
          valueListenable: title,
          builder: (BuildContext context, String value, _) {
            return Row(
              children: [
                Consumer<UserDataNotifier>(
                  builder: (context, userDataNotifier, _) {
                    List<UserData> userDataList = userDataNotifier.allUserDatas;

                    // If no data is fetched. Show 'No user data available'.
                    if (userDataList == null || userDataList.isEmpty) {
                      return Text(
                        'No user data available',
                        style: TextStyle(color: Colors.black),
                      );
                    }

                    final userData = userDataList[0];

                    print('The username: ' + userData.username);

                    // Show simple welcome text with the fetched userData.
                    return Text('Welcome ${userData.name}' + '!',
                        style: TextStyle(color: Colors.black));
                  },
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          Avatar.small(
            url:
                "https://talhakarakoyunlu.github.io/cv/images/talha%20profile%20picture.png",
          ),
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
    return SafeArea(
      top: false,
      bottom: true,
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
        height: 65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isSelected ? 24 : 20,
              color: isSelected ? AppColors.secondary : null,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              label,
              style: isSelected
                  ? const TextStyle(
                      fontSize: 16,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold)
                  : const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
