import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:theme_provider/theme_provider.dart';

class InputMicButton extends StatefulWidget {
  const InputMicButton(
      {super.key,
      required this.speechToText,
      required this.startListening,
      required this.stopListening});

  final SpeechToText speechToText;
  final Function startListening;
  final Function stopListening;

  @override
  State<InputMicButton> createState() => _InputMicButtonState();
}

class _InputMicButtonState extends State<InputMicButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        widget.speechToText.isNotListening
            ? widget.startListening()
            : widget.stopListening();
      },
      icon: Icon(
        widget.speechToText.isNotListening
            ? Icons.mic_off_outlined
            : Icons.mic_none_outlined,
        color: widget.speechToText.isNotListening
            ? Theme.of(context).iconTheme.color
            : ThemeProvider.themeOf(context).id == "light_theme"
                ? Colors.green[600]
                : Colors.greenAccent,
      ),
    );
  }
}
