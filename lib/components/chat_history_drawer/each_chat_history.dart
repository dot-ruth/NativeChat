// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nativechat/models/chat_session.dart';
import 'package:nativechat/utils/show_toast.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:intl/intl.dart';

class EachChatHistory extends StatefulWidget {
  const EachChatHistory({
    super.key,
    required this.sessions,
    required this.chatBox,
    required this.onChatSelected,
  });

  final List<ChatSessionModel> sessions;
  final Box<ChatSessionModel>? chatBox;
  final Function onChatSelected;

  @override
  State<EachChatHistory> createState() => _EachChatHistoryState();
}

class _EachChatHistoryState extends State<EachChatHistory> {
  int selectedIndex = -1;

  Future<void> deleteSpecificChatHistory(chatBox, sessions, index) async {
    var sessionToDelete = chatBox!.values
        .firstWhere((session) => session.id == sessions[index].id);
    await chatBox!.delete(
      sessionToDelete.key,
    );
  }

  // rename title
  Future<void> renameSpecificChatHistory(
      chatBox, sessions, index, newTitle) async {
    var sessionForRename = chatBox!.values
        .firstWhere((session) => session.id == sessions[index].id);

    sessionForRename.title = newTitle;
    await sessionForRename.save();
    selectedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.sessions.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              // top: index == 0
              //     ? BorderSide(
              //         color: ThemeProvider.themeOf(context).id == "light_theme"
              //             ? Colors.grey[300]!
              //             : Colors.grey[800]!,
              //         width: 0.3,
              //       )
              //     : BorderSide(
              //         color: Colors.transparent,
              //       ),
              bottom: BorderSide(
                color: ThemeProvider.themeOf(context).id == "light_theme"
                    ? Colors.grey[300]!
                    : Colors.grey[800]!,
                width: 0.3,
              ), // Dim border bottom
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.only(
              left: 0.0,
            ),
            title: selectedIndex == index
                ? Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: TextFormField(
                      initialValue: widget.sessions[index].title,
                      style: TextStyle(
                        color:
                            ThemeProvider.themeOf(context).id != "light_theme"
                                ? Colors.grey[300]!
                                : Colors.grey[800]!,
                      ),
                      cursorColor:
                          ThemeProvider.themeOf(context).id == "light_theme"
                              ? Colors.black
                              : Colors.white,
                      decoration: InputDecoration(
                        filled: true,
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Theme.of(context).iconTheme.color!,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 12,
                        ),
                        fillColor:
                            ThemeProvider.themeOf(context).id == "light_theme"
                                ? const Color(0xfff2f2f2)
                                : const Color(0xff1a1a1a),
                      ),
                      onFieldSubmitted: (value) => {
                        if (value.isNotEmpty)
                          {
                            renameSpecificChatHistory(
                              widget.chatBox,
                              widget.sessions,
                              index,
                              value,
                            )
                          }
                      },
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(
                      left: selectedIndex == index ? 0.0 : 12.0,
                    ),
                    child: Text(
                      widget.sessions[index].title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color:
                            ThemeProvider.themeOf(context).id == "light_theme"
                                ? Colors.black
                                : Colors.white,
                      ),
                    ),
                  ),
            subtitle: Padding(
              padding: EdgeInsets.only(
                left: 12.0,
              ),
              child: Text(
                DateFormat('hh:mm a, MMM d, yyyy')
                    .format(widget.sessions[index].createdAt!),
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    selectedIndex = index;
                    setState(() {});
                  },
                  child: Icon(
                    Icons.edit_outlined,
                    size: 17.0,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await deleteSpecificChatHistory(
                      widget.chatBox,
                      widget.sessions,
                      index,
                    );
                    showToast(context, "Deleted Chat History");
                  },
                  icon: Icon(
                    Ionicons.trash_outline,
                    size: 17.0,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ],
            ),
            onTap: () {
              widget.onChatSelected(widget.sessions[index]);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
