import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nativechat/models/chat_session.dart';
import 'package:nativechat/pages/settings_page.dart';
import 'package:nativechat/utils/show_toast.dart';

class ChatHistoryDrawerFooter extends StatefulWidget {
  const ChatHistoryDrawerFooter({
    super.key,
    required this.chatBox,
  });

  final Box<ChatSessionModel>? chatBox;

  @override
  State<ChatHistoryDrawerFooter> createState() =>
      _ChatHistoryDrawerFooterState();
}

class _ChatHistoryDrawerFooterState extends State<ChatHistoryDrawerFooter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 5.0,
        right: 5.0,
        bottom: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Delete All Chats
          Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              icon: Icon(
                Icons.delete_sweep_outlined,
                size: 25.0,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                widget.chatBox?.clear();
                setState(() {});
                showToast(context, "Deleted All Chat History");
              },
            ),
          ),

          // Settings
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SettingsPage();
                }),
              );
            },
            icon: Icon(
              Ionicons.settings_outline,
              size: 20.0,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }
}
