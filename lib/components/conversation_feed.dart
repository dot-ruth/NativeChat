// dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nativechat/components/ai_response.dart';
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
      flex: 3,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 200.0),
        controller: widget.scrollController,
        itemCount: widget.chatHistory.length,
        itemBuilder: (context, index) {
          final chat = widget.chatHistory[index];
          final bool isUser = chat['from'] == "user";
          final bool isSystem = chat['from'] == "system";
          final bool isLast = index == widget.chatHistory.length - 1;

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

          if (chat.containsKey('image') && chat['image'] != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 300,
                      ),
                      child: Image.memory(
                        chat['image'],
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                  ),
                ),
                messageWidget,
              ],
            );
          } else {
            return messageWidget;
          }
        },
      ),
    );
  }
}
