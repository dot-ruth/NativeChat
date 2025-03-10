import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nativechat/models/chat_session.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

class ChatHistoryDrawer extends StatefulWidget {
  final void Function(ChatSessionModel) onChatSelected;
  const ChatHistoryDrawer({super.key, required this.onChatSelected});

  @override
  State<ChatHistoryDrawer> createState() => _ChatHistoryDrawerState();
}

class _ChatHistoryDrawerState extends State<ChatHistoryDrawer> {
  Box<ChatSessionModel>? chatBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    final box = await Hive.openBox<ChatSessionModel>('chat_session');
    setState(() {
      chatBox = box;
    });
  }

  ChatSessionModel createSession() {
    final newSession = ChatSessionModel(title: "New Chat", messages: [],createdAt: DateTime.now());
    chatBox?.add(newSession);
    return newSession;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:  ThemeProvider.themeOf(context).id == "light_theme"
            ? Colors.white
            : const Color(0xff1a1a1a),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(border: Border(bottom: BorderSide.none)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                        Text('Chats', 
                          style: TextStyle( 
                            fontSize: 18,
                            color: ThemeProvider.themeOf(context).id == "light_theme" ? Colors.black:Colors.white
                            )
                         ),
                           GestureDetector(
                             onTap: () {
                             widget.onChatSelected(createSession());
                             setState(() {});
                        },
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.add_circled, size: 20.0),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: chatBox?.listenable() ?? ValueNotifier<Future<Box<ChatSessionModel>>>(Hive.openBox('chat_session')),
              builder: (context, box, _) {
                if (chatBox == null) {
                   return Center(child: CircularProgressIndicator()); 
                }
                var sessions = chatBox!.values.toList().reversed.toList();
                return sessions.isEmpty
                    ? Center(child: Text(
                      "No chat history",
                      style: TextStyle(color: ThemeProvider.themeOf(context).id == "light_theme" ? Colors.black:Colors.white),
                      ))
                    : ListView.builder(
                        itemCount: sessions.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(
                                 bottom: BorderSide(color: Colors.grey.shade300, width: 0.5), // Dim border bottom
                              ),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4), 
                              visualDensity: VisualDensity(vertical: -2), 
                              title: Text(
                                sessions[index].title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: ThemeProvider.themeOf(context).id == "light_theme" ? Colors.black:Colors.white),
                                ),
                              subtitle: 
                                  Text(
                                    DateFormat('MMMM d, yyyy').format(sessions[index].createdAt!),
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                              trailing: IconButton(
                                        onPressed: () async {
                                            var sessionToDelete = chatBox!.values.firstWhere(
                                              (session) => session.id == sessions[index].id
                                              );
                                            await chatBox!.delete(sessionToDelete.key);
                                        },
                                        icon: Icon(
                                          Ionicons.trash,
                                          size: 15,
                                          color: Theme.of(context).iconTheme.color,
                                         ),
                                   ),
                              onTap: () {
                                widget.onChatSelected(sessions[index]);
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      );
              },
            ),
          ),
          Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              icon: Icon(Icons.auto_delete_outlined, size: 20.0),
              onPressed: () {
                chatBox?.clear();
                setState(() {});
              },
            ),
          ),
        ),
        ],
      ),
    );
  }
}
