import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class RemoveAttachmentButton extends StatefulWidget {
  const RemoveAttachmentButton({
    super.key,
    required this.removeAttachment,
    this.isCircular = false,
  });

  final VoidCallback removeAttachment;
  final bool isCircular;

  @override
  State<RemoveAttachmentButton> createState() => _RemoveAttachmentButtonState();
}

class _RemoveAttachmentButtonState extends State<RemoveAttachmentButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.removeAttachment,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: widget.isCircular
            ? BoxDecoration(
                shape: BoxShape.circle,
                color: ThemeProvider.themeOf(context).id == "light_theme"
                    ? Colors.grey[300]
                    : Colors.grey[900],
              )
            : null,
        child: Icon(
          Icons.close,
          size: 18.0,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
