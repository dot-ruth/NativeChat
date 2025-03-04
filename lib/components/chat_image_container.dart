import 'dart:typed_data';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

class ChatImageContainer extends StatefulWidget {
  const ChatImageContainer({
    super.key,
    required this.isOneSidedChatMode,
    required this.image,
  });

  final bool isOneSidedChatMode;
  final Uint8List image;

  @override
  State<ChatImageContainer> createState() => _ChatImageContainerState();
}

class _ChatImageContainerState extends State<ChatImageContainer> {
  void openImage() async {
    final imageProvider = Image.memory(widget.image).image;
    await showImageViewer(
      context,
      imageProvider,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isOneSidedChatMode
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: 8.0,
          left: 12.0,
          right: 12.0,
          bottom: 10.0,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 300,
          ),
          child: GestureDetector(
            onTap: () async {
              openImage();
            },
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Image.memory(
                widget.image,
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
