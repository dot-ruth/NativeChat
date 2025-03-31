import 'package:flutter/material.dart';
import 'package:nativechat/components/chat_feed/codeblock.dart';

class FullScreenCode extends StatefulWidget {
  const FullScreenCode({
    super.key,
    required this.code,
    required this.name,
  });

  final String code;
  final String name;

  @override
  State<FullScreenCode> createState() => _FullScreenCodeState();
}

class _FullScreenCodeState extends State<FullScreenCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              child: Codeblock(
                code: widget.code,
                name: widget.name,
                isFullscreen: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
