import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class PromptSuggestionsFeed extends StatefulWidget {
  const PromptSuggestionsFeed({
    super.key,
    required this.chatWithAI,
    required this.userMessageController,
    required this.toggleCallsContext,
    required this.toggleMessageContext,
    required this.toggleDeviceContext,
  });

  final Function chatWithAI;
  final Function toggleCallsContext;
  final Function toggleMessageContext;
  final Function toggleDeviceContext;
  final TextEditingController userMessageController;

  @override
  State<PromptSuggestionsFeed> createState() => _PromptSuggestionsFeedState();
}

class _PromptSuggestionsFeedState extends State<PromptSuggestionsFeed> {
  var promptSuggestions = [
    {
      'context': "areCallsInContext",
      'prompt': 'Who called me the most?',
    },
    {
      'context': "areMessagesInContext",
      'prompt': 'Tell me my unread text messages?',
    },
    {
      'context': "isDeviceInContext",
      'prompt': 'How many cores does my phone have?',
    },
    {
      'context': "areCallsInContext",
      'prompt': 'What is the longest call I had?',
    },
    {
      'context': "areMessagesInContext",
      'prompt': 'What is the last bank transaction amount I made?',
    },
    {
      'context': "isDeviceInContext",
      'prompt': 'Is my phone charging?',
    },
    {
      'context': "areCallsInContext",
      'prompt': 'Do I have any recent missed calls?',
    },
    {
      'context': "areMessagesInContext",
      'prompt': 'What is the sweetest text I got recently?',
    },
    {
      'context': "isDeviceInContext",
      'prompt': 'How many apps do I have?',
    },
    {
      'context': "",
      'prompt': 'Write code to find the Fibonacci sequence in Zig?',
    },
  ];

  void enterPromptSuggestion(promptObject) {
    if (promptObject["context"] == "areCallsInContext") {
      widget.toggleCallsContext(value: true);
      widget.toggleMessageContext(value: false);
      widget.toggleDeviceContext(value: false);
    } else if (promptObject["context"] == "areMessagesInContext") {
      widget.toggleCallsContext(value: false);
      widget.toggleMessageContext(value: true);
      widget.toggleDeviceContext(value: false);
    } else if (promptObject["context"] == "isDeviceInContext") {
      widget.toggleCallsContext(value: false);
      widget.toggleMessageContext(value: false);
      widget.toggleDeviceContext(value: true);
    }
    setState(() {
      widget.userMessageController.text = promptObject["prompt"];
    });
    widget.chatWithAI();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
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
                    promptSuggestions[index]["prompt"]!,
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
