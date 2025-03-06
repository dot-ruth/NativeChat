import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class VoiceModeButton extends StatefulWidget {
  const VoiceModeButton({
    super.key,
    required this.toggleVoiceMode,
    required this.isInVoiceMode,
  });

  final Function toggleVoiceMode;
  final bool isInVoiceMode;

  @override
  State<VoiceModeButton> createState() => _VoiceModeButtonState();
}

class _VoiceModeButtonState extends State<VoiceModeButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                ? ThemeProvider.themeOf(context).id == "light_theme"
                    ? Colors.green[600]!
                    : Colors.greenAccent
                : Theme.of(context).iconTheme.color!.withAlpha(100),
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Row(
          children: [
            Icon(
              widget.isInVoiceMode ? Icons.mic : Icons.mic_off,
              color: widget.isInVoiceMode
                  ? ThemeProvider.themeOf(context).id == "light_theme"
                      ? Colors.green[600]!
                      : Colors.greenAccent
                  : Theme.of(context).iconTheme.color,
              size: 18.0,
            ),
            const SizedBox(width: 4.0),
            Text(
              'Voice Mode',
              style: TextStyle(
                color: widget.isInVoiceMode
                    ? ThemeProvider.themeOf(context).id == "light_theme"
                        ? Colors.green[600]!
                        : Colors.greenAccent
                    : Theme.of(context).iconTheme.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
