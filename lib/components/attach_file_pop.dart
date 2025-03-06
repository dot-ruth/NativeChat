// dart
import 'package:flutter/material.dart';

enum AttachmentOption { file, image, audio, camera }

class AttachFilePopup extends StatelessWidget {
  final VoidCallback onPickFile;
  final VoidCallback onPickImage;
  final VoidCallback onPickAudio;
  final VoidCallback onPickCamera;

  const AttachFilePopup({
    Key? key,
    required this.onPickFile,
    required this.onPickImage,
    required this.onPickAudio,
    required this.onPickCamera,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AttachmentOption>(
      color: const Color(0xff1a1a1a),
      offset: const Offset(0, -270), // Adjust the Y value as needed
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).iconTheme.color!.withAlpha(100),
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.attach_file, color: Colors.white60, size: 20.0),
            SizedBox(width: 6.0),
            Text(
              'Attach File',
              style: TextStyle(color: Colors.white60),
            ),
          ],
        ),
      ),
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
        PopupMenuItem<AttachmentOption>(
          value: AttachmentOption.file,
          child: ListTile(
            leading: const Icon(Icons.file_present_rounded, color: Colors.white),
            title: const Text('File', style: TextStyle(color: Colors.white)),
          ),
        ),
        PopupMenuItem<AttachmentOption>(
          value: AttachmentOption.image,
          child: ListTile(
            leading: const Icon(Icons.image_rounded, color: Colors.white),
            title: const Text('Image', style: TextStyle(color: Colors.white)),
          ),
        ),
        PopupMenuItem<AttachmentOption>(
          value: AttachmentOption.audio,
          child: ListTile(
            leading: const Icon(Icons.mic, color: Colors.white),
            title: const Text('Audio', style: TextStyle(color: Colors.white)),
          ),
        ),
        PopupMenuItem<AttachmentOption>(
          value: AttachmentOption.camera,
          child: ListTile(
            leading: const Icon(Icons.camera_alt_rounded, color: Colors.white),
            title: const Text('Camera', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}