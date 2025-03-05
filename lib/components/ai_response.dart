import "package:flutter/material.dart";
import "package:gpt_markdown/gpt_markdown.dart";
import "package:ionicons/ionicons.dart";
import "package:nativechat/components/codeblock.dart";
import "package:nativechat/components/dashed_border_exracted.dart";
import "package:theme_provider/theme_provider.dart";

class AIResponse extends StatefulWidget {
  const AIResponse({
    super.key,
    required this.text,
    required this.isOneSidedChatMode,
    this.isLast = false,
  });

  final String text;
  final bool isLast;
  final bool isOneSidedChatMode;

  @override
  State<AIResponse> createState() => _AIResponseState();
}

class _AIResponseState extends State<AIResponse> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.only(
            left: widget.isOneSidedChatMode == true ? 25.0 : 0.0,
          ),
          padding: EdgeInsets.only(
            top: 14.0,
            bottom: widget.isOneSidedChatMode == true ? 25.0 : 14.0,
          ),
          decoration: widget.isOneSidedChatMode == true
              ? BoxDecoration(
                  border: dashedBorderExtracted,
                )
              : BoxDecoration(),
          child: Container(
            margin: EdgeInsets.only(
              left: 6.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: GptMarkdown(
              widget.text,
              style: TextStyle(
                color: ThemeProvider.themeOf(context).id == "light_theme" ? Colors.black : Colors.grey[400]
              ),
              codeBuilder: (context, name, code, closed) =>
                  Codeblock(code: code, name: name),
            ),
          ),
        ),
        widget.isLast == true
            ? Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(
                  left: 16.0,
                ),
                child: Icon(
                  Ionicons.ellipse,
                  size: 18.0,
                  color: Colors.grey[800],
                ),
              )
            : Container(),
      ],
    );
  }
}
