import 'dart:async';

import 'package:call_log_new/call_log_new.dart';
// import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nativechat/components/dashed_border_exracted.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:system_info2/system_info2.dart';
// import 'package:system_info_plus/system_info_plus.dart';

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
  var callsLimit = 100;
  var smsLimit = 100;

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

  var installedAppsString = '';
  var installedAppsLength = 0;

  Future<String> generateAdvancedContext() async {
    var advancedContext =
        'THIS IS THE CONTEXT IN WHICH YOU ARE IN, USE THESE INFORMATION TO IMPROVE ON YOUR ANSWERS. YOU MAY HAVE ACCESS TO CALL LOGS, MESSAGES, CURRENT TIME AND DATE AND BATTERY STATUS AND LEVEL. ONLY USE THIS INFORMATION TO IMPROVE YOUR ANSWERS. AND YOU CAN DISCLOSE ANY OF THIS INFORMATION TO THE USER WHEN ASKED.';

    if (areCallsInContext == true) {
      await Permission.phone.request();
      await Permission.contacts.request();
      // ask for call log permissions

      // Iterable<CallLogEntry> callLogs = await CallLog.get();
      final callLogs = await CallLog.fetchCallLogs();
      // print(
      //     'Name: ${callLogs.first.name.toString()} callType: ${callLogs.first.callType?.name} Number: ${callLogs.first.number} cachedNumberLabel:${callLogs.first.cachedNumberLabel.toString()} duration:${callLogs.first.duration} timestamp:${callLogs.first.timestamp.toString()} simDisplayName: ${callLogs.first.simDisplayName} \n');

      var messageString = '';
      for (var eachCallLog in callLogs) {
        messageString +=
            'Name: ${eachCallLog.name.toString()} callType: ${eachCallLog.callType?.name} Number: ${eachCallLog.number} cachedNumberLabel:${eachCallLog.cachedNumberLabel.toString()} duration:${eachCallLog.duration} timestamp:${eachCallLog.timestamp.toString()} simDisplayName: ${eachCallLog.simDisplayName} \n';
      }

      advancedContext +=
          'YOUR LAST ${callLogs.length} CALL HISTORY: $messageString';
    }

    if (areMessagesInContext == true) {
      await Permission.sms.request();
      // Get SMS
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

    if (isDeviceInContext == true) {
      // Get Battery Level and State
      var battery = Battery();
      var batteryLevel = await battery.batteryLevel;
      var batteryState = await battery.batteryState;

      // Get Installed Apps
      if (installedAppsString == '') {
        await Permission.storage.request();
        List<AppInfo> apps = await InstalledApps.getInstalledApps();
        installedAppsLength = apps.length;
        for (var eachApp in apps) {
          installedAppsString +=
              'AppName: ${eachApp.name} PackageName:${eachApp.packageName} VersionName: ${eachApp.versionName} VersionCode:${eachApp.versionCode} InstalledTimestamp:${eachApp.installedTimestamp.toString()} \n';
        }
      }

      // Get System Info
      // var platformVersion = await DeviceInformation.platformVersion;
      // var imeiNo = await DeviceInformation.deviceIMEINumber;
      // var modelName = await DeviceInformation.deviceModel;
      // var manufacturer = await DeviceInformation.deviceManufacturer;
      // var apiLevel = await DeviceInformation.apiLevel;
      // var deviceName = await DeviceInformation.deviceName;
      // var productName = await DeviceInformation.productName;
      // var cpuType = await DeviceInformation.cpuName;
      // var hardware = await DeviceInformation.hardware;

      const int megabyte = 1024 * 1024;
      var coresInfo = '';
      final processors = SysInfo.cores;
      for (var processor in processors) {
        coresInfo +=
            'Architecture: ${processor.architecture} Name: ${processor.name} Socket: ${processor.socket} Vendor: ${processor.vendor}';
      }

      var systemInfo =
          'Kernel architecture: ${SysInfo.kernelArchitecture} Kernel bitness: ${SysInfo.kernelBitness} Kernel bitness: ${SysInfo.kernelBitness} Kernel name: ${SysInfo.kernelName} Kernel version: ${SysInfo.kernelVersion} Operating system name: ${SysInfo.operatingSystemName} Operating system version: ${SysInfo.operatingSystemVersion} User directory: ${SysInfo.userDirectory} User id: ${SysInfo.userId} User name: ${SysInfo.userName} User space bitness: ${SysInfo.userSpaceBitness} Total physical memory: ${SysInfo.getTotalPhysicalMemory() ~/ megabyte} MB Free physical memory: ${SysInfo.getFreePhysicalMemory() ~/ megabyte} MB Total virtual memory: ${SysInfo.getTotalVirtualMemory() ~/ megabyte} MB Free virtual memory: ${SysInfo.getFreeVirtualMemory() ~/ megabyte} MB Virtual memory size: ${SysInfo.getVirtualMemorySize() ~/ megabyte} MB Number of processors : ${processors.length} And info about each core: $coresInfo';

      // PlatformVersion: $platformVersion IMEI: $imeiNo ModelName: $modelName Manufacturer: $manufacturer API Level: $apiLevel DeviceName: $deviceName ProductName: $productName CPU Type: $cpuType Hardware: $hardware';

      advancedContext +=
          "THE BATTERY LEVEL IS $batteryLevel and it is $batteryState. YOU HAVE $installedAppsLength APPS INSTALLED ON YOUR DEVICE AND HERE THEY AND WHEN YOU RESPOND WITH THE INSTALLED TIMESTAMPS MAKE THEM READABLE: $installedAppsString. DONOT RESPOND IN MARKDOWN WHEN TALKING ABOUT APP INFORMATION. HERE IS THE DEVICE'S SYSTEM INFORMATION $systemInfo";
    }

    // Get current time
    var currentDate = DateTime.now();

    // Add Conversation History
    advancedContext +=
        'THE CURRENT CONVERSATION SESSION HISTORY IS THIS: $chatHistory ';

    // Final Context
    var finalContext =
        '${advancedContext}THE CURRENT DATETIME IS: $currentDate AND ONLY PRESENT IT IN HUMAN READABLE FORMAT IF IT IS RELEVANT. ALWAYS RESPOND WITH MARKDOWN OR LATEX.';
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

  void summarizeText({fromUserInput = false}) async {
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
      systemInstruction: Content(
        'ai',
        [TextPart('Summarize the texts given to you as short as possible.')],
      ),
    );
    var userInput = '';

    // Input from user
    if (fromUserInput == true &&
        userMessageController.text.trim().isEmpty == false) {
      userInput = userMessageController.text.trim();
      userMessageController.clear();
      awaitingResponse(userInput, false);
      final chat = model.startChat(history: []);
      final content = Content.text(userInput);
      final response = await chat.sendMessage(content);
      awaitingResponse(response.text, true);
      animateChatHistoryToBottom();
    } else if (sharedList != null &&
        sharedList!.isNotEmpty &&
        sharedList![0].value != null) {
      // Shared from another app
      var sharedString = '';
      for (var eachSharedContent in sharedList!) {
        sharedString += '${eachSharedContent.value!} ';
      }
      userInput = sharedString;
      awaitingResponse(userInput, false);
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
  bool isDeviceInContext = false;
  bool isSummarizeInContext = false;

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

  void toggleDeviceContext() {
    setState(() {
      isDeviceInContext = !isDeviceInContext;
    });
  }

  void toggleSummarizeContext() {
    setState(() {
      isSummarizeInContext = !isSummarizeInContext;
    });
  }

  var promptSuggestions = [];

  void promptSuggestionBuilder() {
    promptSuggestions = [
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
    ];
  }

  void enterPromptSuggestion(promptObject) {
    if (promptObject["context"] == "areCallsInContext") {
      setState(() {
        areCallsInContext = true;
        areMessagesInContext = false;
        isDeviceInContext = false;
      });
    } else if (promptObject["context"] == "areMessagesInContext") {
      setState(() {
        areMessagesInContext = true;
        areCallsInContext = false;
        isDeviceInContext = false;
      });
    } else if (promptObject["context"] == "isDeviceInContext") {
      setState(() {
        isDeviceInContext = true;
        areCallsInContext = false;
        areMessagesInContext = false;
      });
    }
    setState(() {
      userMessageController.text = promptObject["prompt"];
    });
    ["prompt"];
    chatWithAI();
  }

  late StreamSubscription _intentDataStreamSubscription;
  List<SharedFile>? sharedList;
  @override
  void initState() {
    super.initState();
    chatHistory = [];
    promptSuggestionBuilder();

    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = FlutterSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedFile> value) {
      setState(() {
        sharedList = value;
        summarizeText();
      });
      // print("Shared: getMediaStream ${value.map((f) => f.value).join(",")}");
    }, onError: (err) {});

    // For sharing images coming from outside the app while the app is closed
    FlutterSharingIntent.instance
        .getInitialSharing()
        .then((List<SharedFile> value) {
      // print("Shared: getInitialMedia ${value.map((f) => f.value).join(",")}");
      setState(() {
        sharedList = value;
        summarizeText();
      });
    });

    _intentDataStreamSubscription.onDone(() => summarizeText());
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0f0f0f),
      appBar: AppBar(
        backgroundColor: Color(0xff0f0f0f),
        // title: Text(now.toString()),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                chatHistory = [];
                areCallsInContext = false;
                areMessagesInContext = false;
                isDeviceInContext = false;
                isSummarizeInContext = false;
              });
            },
            icon: Icon(
              Ionicons.trash_sharp,
              size: 18.0,
            ),
          ),
        ],
      ),
      // Chat
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 20.0),
            // Text(
            //   'Sharing data: \n${sharedList}\n',
            //   style: TextStyle(
            //     color: Colors.white,
            //   ),
            // ),
            // Spacer(),
            // Icon(
            //             Ionicons.ellipse,
            //             size: 18.0,
            //             color: Colors.grey[900],
            //           ),

            chatHistory.isEmpty
                ? Expanded(
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
                                  promptSuggestions[index]["prompt"],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Container(
                                  height: 25.0,
                                  margin: const EdgeInsets.only(left: 12.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left:
                                          BorderSide(color: Colors.grey[900]!),
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
                                            const EdgeInsets.only(left: 18.0),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 6.0,
                      children: [
                        SizedBox(width: 5.0),
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
                          state: isDeviceInContext,
                          icon: Ionicons.hardware_chip_outline,
                          label: 'Device',
                          toggleState: toggleDeviceContext,
                        ),
                        SystemContextButtons(
                          state: isSummarizeInContext,
                          icon: Ionicons.pencil_outline,
                          label: 'Summarize',
                          toggleState: toggleSummarizeContext,
                        ),
                      ],
                    ),
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
                            isSummarizeInContext == true
                                ? summarizeText(fromUserInput: true)
                                : chatWithAI();
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
