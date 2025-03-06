// dart
import 'dart:typed_data';
import 'package:flutter/material.dart';

class AttachmentPreview extends StatelessWidget {
  final Uint8List? attachedFileBytes;
  final Uint8List? attachedImageBytes;
  final String? attachedMime;
  final String? attachedFileName;
  final VoidCallback removeAttachment;

  const AttachmentPreview({
    Key? key,
    required this.attachedFileBytes,
    required this.attachedImageBytes,
    required this.attachedMime,
    this.attachedFileName,
    required this.removeAttachment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Uint8List? previewBytes = attachedFileBytes ?? attachedImageBytes;
    if (previewBytes == null) return const SizedBox.shrink();

    final bool isImage =
        attachedMime != null && attachedMime!.startsWith('image/');
    final bool isAudio =
        attachedMime != null && attachedMime!.startsWith('audio/');

    // Use the actual file name if provided and non-empty, otherwise fallback.
    final String displayName = (attachedFileName != null && attachedFileName!.isNotEmpty)
        ? attachedFileName!
        : (isAudio ? 'Audio File Attached' : 'Preview File');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondary.withAlpha(25),
                  Theme.of(context).colorScheme.secondary.withAlpha(50),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 8.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: isImage
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.memory(
                previewBytes,
                height: 100,
                fit: BoxFit.fitHeight,
              ),
            )
                : Row(
              children: [
                Icon(
                  isAudio ? Icons.audiotrack : Icons.insert_drive_file_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32.0,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 4.0,
            right: 4.0,
            child: InkWell(
              onTap: removeAttachment,
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black45,
                ),
                child: const Icon(
                  Icons.close,
                  size: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}