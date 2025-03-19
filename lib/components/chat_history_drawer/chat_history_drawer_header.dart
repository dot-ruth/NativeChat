import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nativechat/models/chat_session.dart';
import 'package:theme_provider/theme_provider.dart';

class ChatHistoryDrawerHeader extends StatefulWidget {
  const ChatHistoryDrawerHeader({
    super.key,
    required this.onChatSelected,
    required this.chatBox,
  });

  final void Function(ChatSessionModel) onChatSelected;
  final Box<ChatSessionModel>? chatBox;

  @override
  State<ChatHistoryDrawerHeader> createState() =>
      _ChatHistoryDrawerHeaderState();
}

class _ChatHistoryDrawerHeaderState extends State<ChatHistoryDrawerHeader> {
  ChatSessionModel createSession() {
    final newSession = ChatSessionModel(
      title: "New Chat",
      messages: [],
      createdAt: DateTime.now(),
    );
    widget.chatBox?.add(newSession);
    return newSession;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 45.0,
        left: 15.0,
        right: 5.0,
        // bottom: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Chats',
            style: TextStyle(
              fontSize: 18,
              color: ThemeProvider.themeOf(context).id == "light_theme"
                  ? Colors.black
                  : Colors.white,
            ),
          ),

          // Start New Chat Button
          IconButton(
            onPressed: () {
              widget.onChatSelected(createSession());
              setState(() {});
            },
            icon: Icon(
              Icons.add,
              size: 20.0,
              color: ThemeProvider.themeOf(context).id == "light_theme"
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
