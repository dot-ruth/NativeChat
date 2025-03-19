import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nativechat/components/chat_history_drawer/chat_history_drawer_footer.dart';
import 'package:nativechat/components/chat_history_drawer/chat_history_drawer_header.dart';
import 'package:nativechat/components/chat_history_drawer/each_chat_history.dart';
import 'package:nativechat/components/chat_history_drawer/no_chat_history.dart';
import 'package:nativechat/models/chat_session.dart';
import 'package:theme_provider/theme_provider.dart';

class ChatHistoryDrawer extends StatefulWidget {
  const ChatHistoryDrawer({
    super.key,
    required this.onChatSelected,
  });

  final void Function(ChatSessionModel) onChatSelected;

  @override
  State<ChatHistoryDrawer> createState() => _ChatHistoryDrawerState();
}

class _ChatHistoryDrawerState extends State<ChatHistoryDrawer> {
  Box<ChatSessionModel>? chatBox;

  Future<void> openBox() async {
    final box = await Hive.openBox<ChatSessionModel>('chat_session');
    setState(() {
      chatBox = box;
    });
  }

  @override
  void initState() {
    super.initState();
    openBox();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ThemeProvider.themeOf(context).id == "light_theme"
          ? Colors.white
          : const Color(0xff1a1a1a),
      child: Column(
        children: [
          // Header
          ChatHistoryDrawerHeader(
            onChatSelected: widget.onChatSelected,
            chatBox: chatBox,
          ),

          // History List
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: chatBox?.listenable() ??
                  ValueNotifier<Future<Box<ChatSessionModel>>>(
                    Hive.openBox('chat_session'),
                  ),
              builder: (context, box, _) {
                if (chatBox == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<ChatSessionModel> sessions =
                    chatBox!.values.toList().reversed.toList();
                return sessions.isEmpty
                    ? NoChatHistory()
                    : EachChatHistory(
                        sessions: sessions,
                        chatBox: chatBox,
                        onChatSelected: widget.onChatSelected,
                      );
              },
            ),
          ),

          // Delete All Chats and Settings
          ChatHistoryDrawerFooter(chatBox: chatBox),
        ],
      ),
    );
  }
}
