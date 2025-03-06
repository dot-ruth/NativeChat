import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SendInputButton extends StatefulWidget {
  const SendInputButton({
    super.key,
    required this.isSummarizeInContext,
    required this.summarizeText,
    required this.chatWithAI,
  });

  final bool isSummarizeInContext;
  final Function summarizeText;
  final Function chatWithAI;

  @override
  State<SendInputButton> createState() => _SendInputButtonState();
}

class _SendInputButtonState extends State<SendInputButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        widget.isSummarizeInContext
            ? widget.summarizeText(fromUserInput: true)
            : widget.chatWithAI();
      },
      icon: Icon(
        Ionicons.paper_plane_outline,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
