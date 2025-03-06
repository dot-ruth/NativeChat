import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:nativechat/components/chat_feed/dashed_border_exracted.dart';

class SystemResponse extends StatefulWidget {
  const SystemResponse({
    super.key,
    required this.chatObject,
    required this.isOneSidedChatMode,
  });

  final dynamic chatObject;
  final bool isOneSidedChatMode;

  @override
  State<SystemResponse> createState() => _SystemResponseState();
}

class _SystemResponseState extends State<SystemResponse> {
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
              vertical: 5.0,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                // FadeAnimatedText(
                //   widget.text,
                //   textStyle: TextStyle(
                //     color: Colors.grey[600],
                //     fontSize: 14.0,
                //   ),
                //   duration: Duration(milliseconds: 1000),
                // ),
                ColorizeAnimatedText(
                  widget.chatObject['content'].toString().trim(),
                  textStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14.0,
                  ),
                  colors: [
                    widget.chatObject['isError']
                        ? Colors.redAccent
                        : Colors.grey[700]!,
                    Colors.grey[800]!,
                    Colors.grey[900]!,
                  ],
                  speed: Duration(milliseconds: 100),
                ),
              ],
              totalRepeatCount: 4,
              // pause: const Duration(milliseconds: 1000),
              // displayFullTextOnTap: true,
              // stopPauseOnTap: true,
              // controller: myAnimatedTextController,
            ),
            // Text(
            //   widget.text,
            //   style: TextStyle(
            //     color: Colors.grey[500],
            //   ),
            // ),
          ),
        ),
      ],
    );
  }
}
