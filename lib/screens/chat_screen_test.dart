import 'package:chat_app/models/contact_data.dart';
import 'package:chat_app/models/message_data_2.dart';
import 'package:chat_app/models/models.dart';
import 'package:chat_app/models/user_data.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utility/message_data_notifier.dart';
import 'package:chat_app/widgets/glowing_action_button.dart';
import 'package:chat_app/widgets/icon_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/avatar.dart';

class ChatScreenTest extends StatelessWidget {

  const ChatScreenTest({
    Key? key,
    required this.signedInUserData,
    required this.contactData
  }) : super(key: key);

  final UserData signedInUserData;
  final ContactData contactData;

  @override
  Widget build(BuildContext context) {

    List<MessageData2> messageData = context.watch<MessageDataNotifier>().messages;

    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 54,
        leading: Align(
          alignment: Alignment.centerRight,
          child: IconBackground(
            icon: CupertinoIcons.back,
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: _AppBarTitle(
          contactUserData: contactData.contactUser!,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: IconBorder(
                icon: CupertinoIcons.video_camera_solid,
                onTap: () {},
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: IconBorder(
                icon: CupertinoIcons.phone_solid,
                onTap: () {},
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _DemoMessageList(senderId: signedInUserData.id,),
          ),
          _ActionBar(
            senderId: signedInUserData.id,
            receiverId: contactData.contactUser!.id,
          ),
        ],
      ),
    );
  }
}

class _DemoMessageList extends StatefulWidget {
  const _DemoMessageList({required this.senderId});

  final int senderId;

  @override
  State<_DemoMessageList> createState() => _DemoMessageListState();
}

class _DemoMessageListState extends State<_DemoMessageList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Scroll to the bottom when the widget is first built
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollToBottom();
    // });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: StreamBuilder<List<MessageData2>>(
        stream: context.watch<MessageDataNotifier>().messageStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MessageData2> messages = snapshot.data!;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
            return ListView.builder(
              controller: _scrollController,
              itemCount: messages.length > 0 ? messages.length : 1,
              itemBuilder: (context, index) {
                if (messages.length > 0) {
                  MessageData2 message = messages[index];
                  if (message.sender_id == widget.senderId) {
                    return MessageTile(
                      message: message.message,
                      messageDate: message.created_at.toString(),
                      messageType: MessageType.sent,
                    );
                  } else {
                    return MessageTile(
                      message: message.message,
                      messageDate: message.created_at.toString(),
                      messageType: MessageType.received,
                    );
                  }
                } else {
                  return Center(
                    child: ListTile(
                      title: Text("No messages available"),
                    ),
                  );
                }
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

enum MessageType {
  received,
  sent,
}

class MessageTile extends StatelessWidget {
  const MessageTile({
    Key? key,
    required this.message,
    required this.messageDate,
    required this.messageType,
  }) : super(key: key);

  final String message;
  final String messageDate;
  final MessageType messageType;

  static const _borderRadius = 26.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: messageType == MessageType.received
          ? _MessageTile(
        message: message,
        messageDate: messageDate,
      )
          : _MessageOwnTile(
        message: message,
        messageDate: messageDate,
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({
    Key? key,
    required this.message,
    required this.messageDate,
  }) : super(key: key);

  final String message;
  final String messageDate;

  static const _borderRadius = 26.0;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(_borderRadius),
                topRight: Radius.circular(_borderRadius),
                bottomRight: Radius.circular(_borderRadius),
              ),
            ),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textLight,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 11,
            ),
            child: Text(
              messageDate,
              style: const TextStyle(
                color: AppColors.textFaded,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _MessageOwnTile extends StatelessWidget {
  const _MessageOwnTile({
    Key? key,
    required this.message,
    required this.messageDate,
  }) : super(key: key);

  final String message;
  final String messageDate;

  static const _borderRadius = 26.0;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_borderRadius),
                bottomRight: Radius.circular(_borderRadius),
                bottomLeft: Radius.circular(_borderRadius),
              ),
            ),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textLight,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 11,
            ),
            child: Text(
              messageDate,
              style: const TextStyle(
                color: AppColors.textFaded,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}


class _DateLable extends StatelessWidget {
  const _DateLable({
    Key? key,
    required this.lable,
  }) : super(key: key);

  final String lable;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: Text(
              lable,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textFaded,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({Key? key, required this.contactUserData}) : super(key: key);

  final UserData contactUserData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar.small(
          url: contactUserData.profilePictureURL,
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contactUserData.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 2),
              const Text(
                "Online",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.senderId, required this.receiverId});

  final int senderId;
  final int receiverId;

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();

    return SafeArea(
      bottom: true,
      top: false,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                right:
                    BorderSide(width: 2, color: Theme.of(context).dividerColor),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                CupertinoIcons.camera_fill,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: TextField(
                controller: messageController,
                style: TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: "Type something here",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 24, bottom: 10, top: 10),
            child: GlowingActionButton(
              color: AppColors.accent,
              icon: Icons.send_rounded,
              onPressed: () {

                //TODO: Send a message. DONE✅
                context.read<MessageDataNotifier>().addNewMessage(messageController.text, senderId, receiverId, 'sent');
                messageController.clear();

              },
            ),
          )
        ],
      ),
    );
  }
}
