// dart
// File: lib/components/chat_image_container.dart
import 'dart:typed_data';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:nativechat/components/user_input.dart';

class ChatImageContainer extends StatefulWidget {
  final bool isOneSidedChatMode;
  final Uint8List image;
  final String prompt;

  const ChatImageContainer({
    super.key,
    required this.isOneSidedChatMode,
    required this.image,
    this.prompt = "",
  });

  @override
  State<ChatImageContainer> createState() => _ChatImageContainerState();
}

class _ChatImageContainerState extends State<ChatImageContainer> {
  void openImage() async {
    final imageProvider = Image.memory(widget.image).image;
    await showImageViewer(context, imageProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isOneSidedChatMode ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: GestureDetector(
            onTap: openImage,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Display the image
                  Image.memory(
                    widget.image,
                    fit: BoxFit.cover,
                    height: 200,
                  ),

                  if (widget.prompt.trim().isNotEmpty)
                    UserInput(
                      text: widget.prompt,
                      isOneSidedChatMode: widget.isOneSidedChatMode,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}