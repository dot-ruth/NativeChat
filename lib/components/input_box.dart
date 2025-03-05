// dart
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:theme_provider/theme_provider.dart';

class InputBox extends StatefulWidget {
  const InputBox({
    super.key,
    required this.summarizeText,
    required this.chatWithAI,
    required this.attachFile,
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
  final Function attachFile; // New
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
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: ThemeProvider.themeOf(context).id == "light_theme" ? const Color(0xfff2f2f2) : const Color(0xff1a1a1a)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.isInVoiceMode
              ? Container()
              : Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.userMessageController,
                        cursorColor: ThemeProvider.themeOf(context).id == "light_theme" ? Colors.black : Colors.white,
                        style: TextStyle(color: ThemeProvider.themeOf(context).id == "light_theme" ? Colors.black : Colors.white),
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "ask about anything...",
                          hintStyle: TextStyle(color: ThemeProvider.themeOf(context).id == "light_theme" ? Colors.black : Colors.grey[500]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.attachFile();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              Theme.of(context).iconTheme.color!.withAlpha(100),
                        ),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.attach_file_outlined,
                            color: Theme.of(context).iconTheme.color,
                            size: 18.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            'Attach File',
                            style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
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
                        children: [
                          Icon(
                            widget.isInVoiceMode ? Icons.mic : Icons.mic_off,
                            color: widget.isInVoiceMode
                                ? Colors.greenAccent
                                : Theme.of(context).iconTheme.color,
                            size: 18.0,
                          ),
                          const SizedBox(width: 4.0),
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
                        widget.isSummarizeInContext
                            ? widget.summarizeText(fromUserInput: true)
                            : widget.chatWithAI();
                      },
                      icon: Icon(
                        Icons.send,
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
