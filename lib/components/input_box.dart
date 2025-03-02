import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:speech_to_text/speech_to_text.dart';

class InputBox extends StatefulWidget {
  const InputBox({
    super.key,
    required this.summarizeText,
    required this.chatWithAI,
    required this.isSummarizeInContext,
    required this.userMessageController,
    required this.toggleVoiceMode,
    required this.isInVoiceMode,
    required this.speechToText,
    required this.startListening,
    required this.stopListening,
  });

  final Function summarizeText;
  final Function chatWithAI;
  final bool isSummarizeInContext;
  final TextEditingController userMessageController;
  final Function toggleVoiceMode;
  final SpeechToText speechToText;
  final Function startListening;
  final Function stopListening;
  final bool isInVoiceMode;

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  bool isVoiceMode = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 18.0,
        right: 8.0,
        top: 2.0,
        bottom: 10.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              20.0,
            ),
            topRight: Radius.circular(
              20.0,
            )),
        color: Color(0xff1a1a1a),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.isInVoiceMode
              ? Container()
              : Row(
                  children: [
                    // InputBox
                    Expanded(
                      child: TextField(
                        controller: widget.userMessageController,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "ask about anything...",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 12.0,
                children: [
                  // Attach Files
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 15.0,
                  //       vertical: 6.0,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       border: Border.all(
                  //         color:
                  //             Theme.of(context).iconTheme.color!.withAlpha(100),
                  //       ),
                  //       borderRadius: BorderRadius.circular(100.0),
                  //     ),
                  //     child: Row(
                  //       spacing: 4.0,
                  //       children: [
                  //         Icon(
                  //           Icons.attach_file_outlined,
                  //           color: Theme.of(context).iconTheme.color,
                  //           size: 18.0,
                  //         ),
                  //         Text(
                  //           'Attach File',
                  //           style: TextStyle(
                  //             color: Theme.of(context).iconTheme.color,
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Voice Mode
                  GestureDetector(
                    onTap: () {
                      widget.toggleVoiceMode();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: widget.isInVoiceMode
                              ? Colors.greenAccent
                              : Theme.of(context)
                                  .iconTheme
                                  .color!
                                  .withAlpha(100),
                        ),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Row(
                        spacing: 4.0,
                        children: [
                          Icon(
                            widget.isInVoiceMode ? Icons.mic : Icons.mic_off,
                            color: widget.isInVoiceMode
                                ? Colors.greenAccent
                                : Theme.of(context).iconTheme.color,
                            size: 18.0,
                          ),
                          Text(
                            'Voice Mode',
                            style: TextStyle(
                              color: widget.isInVoiceMode
                                  ? Colors.greenAccent
                                  : Theme.of(context).iconTheme.color,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Send and Mic Button
              widget.isInVoiceMode
                  ? IconButton(
                      onPressed: () {
                        widget.speechToText.isNotListening
                            ? widget.startListening()
                            : widget.stopListening();
                      },
                      icon: Icon(
                        widget.speechToText.isNotListening
                            ? Icons.mic_off
                            : Icons.mic,
                        color: widget.speechToText.isNotListening
                            ? Theme.of(context).iconTheme.color
                            : Colors.greenAccent,
                      ),
                    )
                  : IconButton(
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
        ],
      ),
    );
  }
}
