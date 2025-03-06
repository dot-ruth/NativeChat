// dart
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nativechat/components/attach_file_popup_menu/attach_file_button.dart';
import 'package:nativechat/components/attach_file_popup_menu/each_popup_menu_item.dart';
import 'package:theme_provider/theme_provider.dart';

enum AttachmentOption { file, image, audio, camera }

class AttachFilePopupMenu extends StatelessWidget {
  final VoidCallback onPickFile;
  final VoidCallback onPickImage;
  final VoidCallback onPickAudio;
  final VoidCallback onPickCamera;

  const AttachFilePopupMenu({
    super.key,
    required this.onPickFile,
    required this.onPickImage,
    required this.onPickAudio,
    required this.onPickCamera,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AttachmentOption>(
      color: ThemeProvider.themeOf(context).id == "light_theme"
          ? const Color(0xfff2f2f2)
          : const Color(0xff1a1a1a),
      // offset: const Offset(0, -260), // Adjust the Y value as needed
      borderRadius: BorderRadius.circular(100.0),
      child: AttachFileButton(),
      onSelected: (AttachmentOption option) {
        switch (option) {
          case AttachmentOption.file:
            onPickFile();
            break;
          case AttachmentOption.image:
            onPickImage();
            break;
          case AttachmentOption.audio:
            onPickAudio();
            break;
          case AttachmentOption.camera:
            onPickCamera();
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<AttachmentOption>>[
        EachPopupMenuItem(
          attachmentOption: AttachmentOption.file,
          icon: Ionicons.folder_open_outline,
          title: 'File',
        ),
        EachPopupMenuItem(
          attachmentOption: AttachmentOption.audio,
          icon: Icons.multitrack_audio_outlined,
          title: 'Audio',
        ),
        EachPopupMenuItem(
          attachmentOption: AttachmentOption.image,
          icon: Ionicons.image_outline,
          title: 'Photos',
        ),
        EachPopupMenuItem(
          attachmentOption: AttachmentOption.camera,
          icon: Icons.camera_alt_outlined,
          title: 'Camera',
        ),
      ],
    );
  }
}
