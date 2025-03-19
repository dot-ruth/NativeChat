import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class NoChatHistory extends StatefulWidget {
  const NoChatHistory({super.key});

  @override
  State<NoChatHistory> createState() => _NoChatHistoryState();
}

class _NoChatHistoryState extends State<NoChatHistory> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No chat history",
        style: TextStyle(
          color: ThemeProvider.themeOf(context).id == "light_theme"
              ? Colors.black
              : Colors.white,
        ),
      ),
    );
  }
}
