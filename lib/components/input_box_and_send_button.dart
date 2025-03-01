import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class InputBoxAndSendButton extends StatefulWidget {
  const InputBoxAndSendButton({
    super.key,
    required this.summarizeText,
    required this.chatWithAI,
    required this.isSummarizeInContext,
    required this.userMessageController,
  });

  final Function summarizeText;
  final Function chatWithAI;
  final bool isSummarizeInContext;
  final TextEditingController userMessageController;

  @override
  State<InputBoxAndSendButton> createState() => _InputBoxAndSendButtonState();
}

class _InputBoxAndSendButtonState extends State<InputBoxAndSendButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 18.0,
        right: 8.0,
        top: 2.0,
        bottom: 15.0,
      ),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(30.0),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              20.0,
            ),
            topRight: Radius.circular(
              20.0,
            )),
        color: Color(0xff1a1a1a),
      ),
      child: Row(
        children: [
          // InputBox
          Expanded(
            child: TextField(
              controller: widget.userMessageController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "ask about anything...",
                hintStyle: TextStyle(color: Colors.grey[700]),
                border: InputBorder.none,
              ),
            ),
          ),
          // Send Button
          IconButton(
            onPressed: () {
              widget.isSummarizeInContext == true
                  ? widget.summarizeText(fromUserInput: true)
                  : widget.chatWithAI();
            },
            icon: Icon(
              Ionicons.paper_plane_outline,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }
}
