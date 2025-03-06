import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nativechat/components/attachment_preview/remove_attachment_button.dart';
import 'package:theme_provider/theme_provider.dart';

class AttachedFilePreview extends StatefulWidget {
  const AttachedFilePreview({
    super.key,
    required this.isAudio,
    required this.displayName,
    required this.removeAttachment,
  });

  final bool isAudio;
  final String displayName;
  final VoidCallback removeAttachment;

  @override
  State<AttachedFilePreview> createState() => _AttachedFilePreviewState();
}

class _AttachedFilePreviewState extends State<AttachedFilePreview> {
  @override
  Widget build(BuildContext context) {
    var color = ThemeProvider.themeOf(context).id == "light_theme"
        ? Colors.black
        : Colors.white;

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: ThemeProvider.themeOf(context).id == "light_theme"
            ? const Color(0xfff2f2f2)
            : const Color(0xff1a1a1a),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 5.0,
        top: 5.0,
        bottom: 6.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 10.0,
            children: [
              Icon(
                widget.isAudio
                    ? Icons.multitrack_audio_outlined
                    : Ionicons.folder_open_outline,
                color: color,
                size: 18.0,
              ),
              SizedBox(
                width: 150.0,
                child: Text(
                  widget.displayName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          RemoveAttachmentButton(
            removeAttachment: widget.removeAttachment,
          ),
        ],
      ),
    );
  }
}
