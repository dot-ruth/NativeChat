// dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nativechat/components/attachment_preview/attached_file_preview.dart';
import 'package:nativechat/components/attachment_preview/attached_image_preview.dart';

class AttachmentPreview extends StatelessWidget {
  final Uint8List? attachedFileBytes;
  final Uint8List? attachedImageBytes;
  final String? attachedMime;
  final String? attachedFileName;
  final VoidCallback removeAttachment;

  const AttachmentPreview({
    super.key,
    required this.attachedFileBytes,
    required this.attachedImageBytes,
    required this.attachedMime,
    this.attachedFileName,
    required this.removeAttachment,
  });

  @override
  Widget build(BuildContext context) {
    // File Content
    final Uint8List? previewBytes = attachedFileBytes ?? attachedImageBytes;
    if (previewBytes == null) return const SizedBox.shrink();

    // Check if the attached file is an image or audio file.
    final bool isImage =
        attachedMime != null && attachedMime!.startsWith('image/');
    final bool isAudio =
        attachedMime != null && attachedMime!.startsWith('audio/');

    // Use the actual file name if provided and non-empty, otherwise fallback.
    final String displayName =
        (attachedFileName != null && attachedFileName!.isNotEmpty)
            ? attachedFileName!
            : (isAudio ? 'Audio File Attached' : 'Preview File');

    return isImage
        ? AttachedImagePreview(
            previewBytes: previewBytes,
            removeAttachment: removeAttachment,
          )
        : AttachedFilePreview(
            isAudio: isAudio,
            displayName: displayName,
            removeAttachment: removeAttachment,
          );
  }
}
