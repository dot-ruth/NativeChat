// dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nativechat/components/ai_response.dart';
import 'package:nativechat/components/chat_image_container.dart';
import 'package:nativechat/components/system_response.dart';
import 'package:nativechat/components/user_input.dart';

class ConversationFeed extends StatefulWidget {
  const ConversationFeed({
    super.key,
    required this.scrollController,
    required this.chatHistory,
    required this.isOneSidedChatMode,
  });

  final ScrollController scrollController;
  final List<dynamic> chatHistory;
  final bool isOneSidedChatMode;

  @override
  State<ConversationFeed> createState() => _ConversationFeedState();
}

class _ConversationFeedState extends State<ConversationFeed> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 200.0),
        controller: widget.scrollController,
        itemCount: widget.chatHistory.length,
        itemBuilder: (context, index) {
          final chat = widget.chatHistory[index];
          final bool isUser = chat['from'] == "user";
          final bool isSystem = chat['from'] == "system";
          final bool isLast = index == widget.chatHistory.length - 1;

          // Handle file attachments
          if (chat.containsKey('file') && chat['file'] != null) {
            final fileData = chat['file'];

            if (fileData['isImage'] == true) {
              // Display as image if it's an image file
              return ChatImageContainer(
                isOneSidedChatMode: widget.isOneSidedChatMode,
                image: fileData['bytes'],
              );
            } else {
              // Display file icon and name for non-image files
              return Container(
                margin: EdgeInsets.only(
                  left: widget.isOneSidedChatMode ? 16.0 : 64.0,
                  right: widget.isOneSidedChatMode ? 64.0 : 16.0,
                  top: 8.0,
                  bottom: 8.0,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: isUser
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.insert_drive_file_rounded,
                      color: Colors.black87,
                      size: 24.0,
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        fileData['name'] ?? 'File',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          // Handle legacy images
          else if (chat.containsKey('image') && chat['image'] != null) {
            return ChatImageContainer(
              isOneSidedChatMode: widget.isOneSidedChatMode,
              image: chat['image'],
            );
          }

          // Handle regular messages
          Widget messageWidget;

          if (isSystem) {
            messageWidget = widget.isOneSidedChatMode == false
                ? SystemResponse(
              chatObject: chat,
              isOneSidedChatMode: widget.isOneSidedChatMode,
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SystemResponse(
                  chatObject: chat,
                  isOneSidedChatMode: widget.isOneSidedChatMode,
                ),
                chat["isError"] == true
                    ? isLast == true
                    ? Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Icon(
                    Ionicons.ellipse,
                    size: 18.0,
                    color: Colors.grey[900],
                  ),
                )
                    : Container()
                    : Container(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: LoadingAnimationWidget.beat(
                    color: Colors.grey[600]!,
                    size: 14,
                  ),
                ),
              ],
            );
          } else if (isUser) {
            messageWidget = UserInput(
              text: chat['content'],
              isOneSidedChatMode: widget.isOneSidedChatMode,
            );
          } else {
            messageWidget = AIResponse(
              text: chat['content'].toString(),
              isLast: isLast,
              isOneSidedChatMode: widget.isOneSidedChatMode,
            );
          }

          return messageWidget;
        },
      ),
    );
  }
}