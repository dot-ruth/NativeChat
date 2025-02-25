import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../components/ai_response.dart';
import '../components/system_context_buttons.dart';
import '../components/user_input.dart';
// import 'package:call_log/call_log.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController userMessageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  var chatHistory = [
    {"from": "user", "content": "Hey there!", "timestamp": "12:34"},
    {
      "from": "ai",
      "content": "Hey there! How can I help you today?",
      "timestamp": "12:35",
    },
    {"from": "user", "content": "Yes, What is the time?", "timestamp": "12:34"},
    {
      "from": "ai",
      "content": "You're in luck cause I know the time",
      "timestamp": "12:35",
    },
    {
      "from": "user",
      "content": "Summarize, my last text message",
      "timestamp": "12:34",
    },
    {
      "from": "ai",
      "content":
          "You're in luck cause I know the time. You're in luck cause I know the time. You're in luck cause I know the time. You're in luck cause I know the time. You're in luck cause I know the time. You're in luck cause I know the time. You're in luck cause I know the time.",
      "timestamp": "12:35",
    },
  ];

  Future<String> generateAdvancedContext() async {
    var advancedContext =
        'THIS IS THE CONTEXT IN WHICH YOU ARE IN, USE THESE INFORMATION TO IMPROVE ON YOUR ANSWERS. YOU MAY HAVE ACCESS TO CALL LOGS, MESSAGES, CURRENT TIME AND DATE AND BATTERY STATUS AND LEVEL. ONLY USE THIS INFORMATION TO IMPROVE YOUR ANSWERS. AND YOU CAN DISCLOSE ANY OF THIS INFORMATION TO THE USER WHEN ASKED.';

    // if (areCallsInContext == true) {
    //   await Permission.contacts.request();
    //   var callsLimit = 10;
    //   Iterable<CallLogEntry> callLogs = await CallLog.get();
    //   advancedContext += 'YOUR LAST $callsLimit CALL HISTORY: $callLogs';
    // }

    if (areMessagesInContext == true) {
      await Permission.sms.request();
      // Get SMS
      var smsLimit = 100;
      SmsQuery query = SmsQuery();
      var allSMS = await query.querySms(
        count: smsLimit,
        kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
      );

      var messageString = '';
      for (var eachMessage in allSMS) {
        messageString +=
            'ID: ${eachMessage.id} From:${eachMessage.sender!} Content:${eachMessage.body!} Date:${eachMessage.date.toString()} isRead: ${eachMessage.isRead} kind(Sent or Recived): ${eachMessage.kind} \n';
      }

      advancedContext += 'YOUR LAST $smsLimit SMS HISTORY: $messageString';
    }

    if (isBatteryInContext == true) {
      // Get Battery Level and State
      var battery = Battery();
      var batteryLevel = await battery.batteryLevel;
      var batteryState = await battery.batteryState;

      advancedContext +=
          'THE BATTERY LEVEL IS $batteryLevel and it is $batteryState';
    }

    // Get current time
    var currentDate = DateTime.now();

    // Add Conversation History
    advancedContext +=
        'THE CURRENT CONVERSATION SESSION HISTORY IS THIS: $chatHistory ';

    // Final Context
    var finalContext =
        '${advancedContext}THE CURRENT DATETIME IS: $currentDate AND ONLY PRESENT IT IN HUMAN READABLE FORMAT IF IT IS RELEVANT. DONOT RESPOND WITH MARKDOWN';
    return finalContext;
  }

  void chatWithAI() async {
    if (userMessageController.text.trim().isEmpty == false) {
      var userInput = userMessageController.text.trim();
      userMessageController.clear();
      awaitingResponse(userInput, false);

      var advancedContext = await generateAdvancedContext();

      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: 'AIzaSyAnYR1BsRBqpCOk2taz51wwROcOF69L8oU',
        generationConfig: GenerationConfig(
          temperature: 1,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 8192,
          responseMimeType: 'text/plain',
        ),
        systemInstruction: Content('ai', [TextPart(advancedContext)]),
      );

      final chat = model.startChat(history: []);
      final content = Content.text(userInput);

      final response = await chat.sendMessage(content);

      awaitingResponse(response.text, true);
      animateChatHistoryToBottom();
    }
  }

  void animateChatHistoryToBottom() {
    scrollController.animateTo(
      scrollController.position.extentTotal,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void awaitingResponse(content, isFinishhed) {
    if (isFinishhed) {
      setState(() {
        chatHistory.removeAt(chatHistory.length - 1);
        chatHistory.removeAt(chatHistory.length - 1);
        chatHistory.add({
          "from": "ai",
          "content": content,
          "timestamp": "12:35",
        });
      });
    } else {
      setState(() {
        chatHistory.add({
          "from": "user",
          "content": content,
          "timestamp": "12:35",
        });
        chatHistory.add({"from": "ai", "content": '', "timestamp": ""});
        chatHistory.add({"from": "system"});
      });
    }
  }

  bool areMessagesInContext = false;
  bool areCallsInContext = false;
  bool isBatteryInContext = false;

  void toggleCallsContext() {
    setState(() {
      areCallsInContext = !areCallsInContext;
    });
  }

  void toggleMessageContext() {
    setState(() {
      areMessagesInContext = !areMessagesInContext;
    });
  }

  void toggleBatteryContext() {
    setState(() {
      isBatteryInContext = !isBatteryInContext;
    });
  }

  @override
  void initState() {
    super.initState();
    chatHistory = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0f0f0f),
      appBar: AppBar(
        backgroundColor: Color(0xff0f0f0f),
        // title: Text(now.toString()),
      ),
      // Chat
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 20.0),
            // Spacer(),
            chatHistory.isEmpty
                ? Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 31.0),
                    child: Icon(
                      Ionicons.ellipse,
                      size: 18.0,
                      color: Colors.grey[900],
                    ),
                  )
                : Expanded(
                    flex: 3,
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: chatHistory.length,
                      itemBuilder: (context, index) {
                        // final item = chatHistory[index];
                        final bool isUser =
                            chatHistory[index]['from'] == "user";
                        final bool isSystem =
                            chatHistory[index]['from'] == "system";
                        final bool isLast = index == chatHistory.length - 1;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              // mainAxisAlignment: item['from'] == "user"
                              //     ? MainAxisAlignment.end
                              //     : MainAxisAlignment.start,
                              children: [
                                isSystem
                                    ? Container(
                                        padding:
                                            const EdgeInsets.only(left: 33.0),
                                        child: LoadingAnimationWidget.beat(
                                          color: Colors.grey[600]!,
                                          size: 14,
                                        ),
                                      )
                                    : isUser
                                        ? UserInput(
                                            text: chatHistory[index]
                                                ['content']!,
                                          )
                                        : AIResponse(
                                            text: chatHistory[index]
                                                ['content']!,
                                            isLast: isLast,
                                          ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 6.0,
                    children: [
                      SystemContextButtons(
                        state: areCallsInContext,
                        icon: Ionicons.call_outline,
                        label: 'Calls',
                        toggleState: toggleCallsContext,
                      ),
                      SystemContextButtons(
                        state: areMessagesInContext,
                        icon: Ionicons.mail_outline,
                        label: 'Messages',
                        toggleState: toggleMessageContext,
                      ),
                      SystemContextButtons(
                        state: isBatteryInContext,
                        icon: Ionicons.battery_half_outline,
                        label: 'Battery',
                        toggleState: toggleBatteryContext,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      // InputBox
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 18.0,
                            right: 18.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Color(0xff151515),
                          ),
                          child: TextField(
                            controller: userMessageController,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "ask about anything...",
                              hintStyle: TextStyle(color: Colors.grey[700]),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      // Send Button
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          onPressed: () {
                            chatWithAI();
                          },
                          icon: Icon(
                            Ionicons.paper_plane_outline,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
