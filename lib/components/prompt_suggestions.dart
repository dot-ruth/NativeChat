import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class PromptSuggestionsFeed extends StatefulWidget {
  const PromptSuggestionsFeed({
    super.key,
    required this.chatWithAI,
    required this.userMessageController,
  });

  final Function chatWithAI;
  final TextEditingController userMessageController;

  @override
  State<PromptSuggestionsFeed> createState() => _PromptSuggestionsFeedState();
}

class _PromptSuggestionsFeedState extends State<PromptSuggestionsFeed> {
  var promptSuggestions = [
    'Who called me the most?',
    'Tell me my unread text messages?',
    'How many cores does my phone have?',
    'What is the longest call I had?',
    'What is the last bank transaction amount I made?',
    'Is my phone charging?',
    'Do I have any recent missed calls?',
    'What is the sweetest text I got recently?',
    'How many apps do I have?',
    'Write code to find the Fibonacci sequence in Zig?',
  ];

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
        padding: const EdgeInsets.only(left: 13.0),
        child: ListView.builder(
          itemCount: promptSuggestions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                enterPromptSuggestion(promptSuggestions[index]);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promptSuggestions[index],
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  Container(
                    height: 25.0,
                    margin: const EdgeInsets.only(left: 12.0),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey[900]!),
                      ),
                    ),
                  ),
                  index == promptSuggestions.length - 1
                      ? Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            left: 4.0,
                          ),
                          child: Icon(
                            Ionicons.ellipse,
                            size: 18.0,
                            color: Colors.grey[900],
                          ),
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
