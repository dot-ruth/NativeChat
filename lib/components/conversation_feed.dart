// dart
import 'package:flutter/material.dart';
import 'package:nativechat/components/ai_response.dart';
import 'package:nativechat/components/chat_image_container.dart';
import 'package:nativechat/components/circle_dot.dart';
import 'package:nativechat/components/circle_loading_animation.dart';
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
                              ? CircleDot(
                                  leftPadding: 16.0,
                                )
                              : Container()
                          : CircleLoadingAnimation()
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
            return ChatImageContainer(
              isOneSidedChatMode: widget.isOneSidedChatMode,
              image: chat['image'],
            );
          } else {
            return messageWidget;
          }
        },
      ),
    );
  }
}
