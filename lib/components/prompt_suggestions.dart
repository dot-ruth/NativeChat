import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nativechat/constants/constants.dart';

class PromptSuggestionsFeed extends StatefulWidget {
  const PromptSuggestionsFeed({
    super.key,
    required this.chatWithAI,
    required this.userMessageController,
    required this.isOneSidedChatMode,
  });

  final Function chatWithAI;
  final TextEditingController userMessageController;
  final bool isOneSidedChatMode;

  @override
  State<PromptSuggestionsFeed> createState() => _PromptSuggestionsFeedState();
}

class _PromptSuggestionsFeedState extends State<PromptSuggestionsFeed> {
  late List<String> randomPromptSuggestions;

  @override
  void initState() {
    super.initState();
    promptSuggestions.shuffle();
    randomPromptSuggestions = promptSuggestions.sublist(0, 10).cast<String>();
    // Sort by character lenght
    randomPromptSuggestions.sort((a, b) => a.length.compareTo(b.length));
  }

  void enterPromptSuggestion(promptObject) {
    setState(() {
      widget.userMessageController.text = promptObject;
    });
    widget.chatWithAI();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 100.0,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(
          left: 13.0,
          top: 30.0,
        ),
        child: ListView.builder(
          itemCount: randomPromptSuggestions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                enterPromptSuggestion(randomPromptSuggestions[index]);
              },
              child: Column(
                crossAxisAlignment: widget.isOneSidedChatMode
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  Text(
                    randomPromptSuggestions[index],
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  Container(
                    height: 25.0,
                    margin: const EdgeInsets.only(left: 12.0),
                    decoration: widget.isOneSidedChatMode
                        ? BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Colors.grey[900]!),
                            ),
                          )
                        : BoxDecoration(),
                  ),
                  index == randomPromptSuggestions.length - 1
                      ? Row(
                          mainAxisAlignment: widget.isOneSidedChatMode
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(
                                left: 4.0,
                              ),
                              child: Icon(
                                Ionicons.ellipse,
                                size: 18.0,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
