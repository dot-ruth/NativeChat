import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nativechat/models/chat_session.dart';
import 'package:theme_provider/theme_provider.dart';

class ChatHistoryDrawerHeader extends StatefulWidget {
  const ChatHistoryDrawerHeader({
    super.key,
    required this.onChatSelected,
    required this.chatBox,
    required this.onSearchChanged,
  });

  final void Function(ChatSessionModel) onChatSelected;
  final Box<ChatSessionModel>? chatBox;
  final Function(String) onSearchChanged;

  @override
  State<ChatHistoryDrawerHeader> createState() =>
      _ChatHistoryDrawerHeaderState();
}

class _ChatHistoryDrawerHeaderState extends State<ChatHistoryDrawerHeader> {
  final TextEditingController _searchController = TextEditingController();

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLightTheme = ThemeProvider.themeOf(context).id == "light_theme";
    return Container(
      padding: const EdgeInsets.only(
        top: 45.0,
        left: 15.0,
        right: 5.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chats',
                style: TextStyle(
                  fontSize: 18,
                  color: isLightTheme ? Colors.black : Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  widget.onChatSelected(createSession());
                  setState(() {});
                },
                icon: Icon(
                  Icons.add,
                  size: 20.0,
                  color: isLightTheme ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          // Search field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search chats",
              prefixIcon: Icon(
                Icons.search,
                color: isLightTheme ? Colors.grey[600] : Colors.grey[400],
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: isLightTheme ? Colors.grey[200] : Colors.grey[800],
            ),
            style: TextStyle(
              color: isLightTheme ? Colors.black : Colors.white,
            ),
            onChanged: widget.onSearchChanged,
          ),
        ],
      ),
    );
  }
}
