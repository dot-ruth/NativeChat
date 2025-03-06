// dart
// File: lib/components/chat_image_container.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nativechat/utils/open_image_fullscreen.dart';

class ChatImageContainer extends StatefulWidget {
  final bool isOneSidedChatMode;
  final Uint8List image;

  const ChatImageContainer({
    super.key,
    required this.isOneSidedChatMode,
    required this.image,
  });

  @override
  State<ChatImageContainer> createState() => _ChatImageContainerState();
}

class _ChatImageContainerState extends State<ChatImageContainer> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isOneSidedChatMode
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 12.0,
        ),
        child: SizedBox(
          height: 150.0,
          width: 150.0,
          child: GestureDetector(
            onTap: () => openImage(context, widget.image),
            child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(12.0),
              child: Image.memory(
                widget.image,
                fit: BoxFit.cover,
                // height: 200,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
