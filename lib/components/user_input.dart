import "package:flutter/material.dart";

class UserInput extends StatefulWidget {
  const UserInput({
    super.key,
    required this.text,
    required this.isOneSidedChatMode,
  });

  final String text;
  final bool isOneSidedChatMode;

  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.isOneSidedChatMode == true
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        Container(
          width: widget.isOneSidedChatMode == true
              ? MediaQuery.of(context).size.width * 0.9
              : MediaQuery.of(context).size.width * 0.7,
          alignment: widget.isOneSidedChatMode == true
              ? Alignment.centerLeft
              : Alignment.centerRight,
          margin: EdgeInsets.only(
            left: 5.0,
            right: widget.isOneSidedChatMode == true ? 0.0 : 5.0,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Container(
            decoration: widget.isOneSidedChatMode
                ? null
                : BoxDecoration(
                    color: Colors.grey[900]!,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
            padding: widget.isOneSidedChatMode
                ? EdgeInsets.all(0.0)
                : EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
            child: Text(
              widget.text,
              textAlign: widget.isOneSidedChatMode == true
                  ? TextAlign.left
                  : TextAlign.right,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
