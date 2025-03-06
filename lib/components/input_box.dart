// File: lib/components/input_box.dart
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:nativechat/components/attach_file_pop.dart';

class InputBox extends StatefulWidget {
  const InputBox({
    super.key,
    required this.summarizeText,
    required this.chatWithAI,
    required this.onPickFile,
    required this.onPickImage,
    required this.onPickAudio,
    required this.onPickCamera,
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
  final VoidCallback onPickFile;
  final VoidCallback onPickImage;
  final VoidCallback onPickAudio;
  final VoidCallback onPickCamera;
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
  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        Theme.of(context).inputDecorationTheme.fillColor ??
            Theme.of(context).scaffoldBackgroundColor;
    final TextStyle textFieldStyle = Theme.of(context).textTheme.bodyLarge ??
        const TextStyle(color: Colors.white);
    final TextStyle hintStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).iconTheme.color,
    ) ??
        TextStyle(color: Theme.of(context).iconTheme.color!);

    return Container(
      padding: const EdgeInsets.only(
        left: 18.0,
        right: 8.0,
        top: 2.0,
        bottom: 10.0,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.isInVoiceMode
              ? const SizedBox.shrink()
              : Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.userMessageController,
                  cursorColor: Theme.of(context).iconTheme.color,
                  style: textFieldStyle,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "ask about anything...",
                    hintStyle: hintStyle,
                    border: InputBorder.none,
                    filled: true,
                    fillColor: backgroundColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AttachFilePopup(
                onPickFile: widget.onPickFile,
                onPickImage: widget.onPickImage,
                onPickAudio: widget.onPickAudio,
                onPickCamera: widget.onPickCamera,
              ),
              const SizedBox(width: 10.0),
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
                          : Theme.of(context).iconTheme.color!.withAlpha(100),
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
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20.0),
              widget.isInVoiceMode
                  ? IconButton(
                onPressed: () {
                  widget.speechToText.isNotListening
                      ? widget.startListening()
                      : widget.stopListening();
                },
                icon: Icon(
                  widget.speechToText.isNotListening ? Icons.mic_off : Icons.mic,
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