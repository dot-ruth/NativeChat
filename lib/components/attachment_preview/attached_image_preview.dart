import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nativechat/components/attachment_preview/remove_attachment_button.dart';
import 'package:nativechat/utils/open_image_fullscreen.dart';
import 'package:theme_provider/theme_provider.dart';

class AttachedImagePreview extends StatefulWidget {
  const AttachedImagePreview({
    super.key,
    required this.previewBytes,
    required this.removeAttachment,
  });

  final Uint8List previewBytes;
  final VoidCallback removeAttachment;

  @override
  State<AttachedImagePreview> createState() => _AttachedImagePreviewState();
}

class _AttachedImagePreviewState extends State<AttachedImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image Preview
        GestureDetector(
          onTap: () => openImage(context, widget.previewBytes),
          child: Container(
            height: 120.0,
            width: 120.0,
            margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: ThemeProvider.themeOf(context).id == "light_theme"
                  ? const Color(0xfff2f2f2)
                  : const Color(0xff1a1a1a),
              // gradient: LinearGradient(
              //   colors: [
              //     Theme.of(context).colorScheme.secondary.withAlpha(25),
              //     Theme.of(context).colorScheme.secondary.withAlpha(50),
              //   ],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withAlpha(25),
              //     blurRadius: 8.0,
              //     offset: const Offset(0, 4),
              //   ),
              // ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.memory(
                widget.previewBytes,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // Remove Attachment Button
        Positioned(
          top: 0.0,
          right: 6.0,
          child: RemoveAttachmentButton(
            removeAttachment: widget.removeAttachment,
            isCircular: true,
          ),
        )
      ],
    );
  }
}
