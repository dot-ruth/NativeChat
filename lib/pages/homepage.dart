import 'dart:async';

import 'package:flutter/material.dart';
import 'package:call_log_new/call_log_new.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nativechat/components/context_toggle_row.dart';
import 'package:nativechat/components/conversation_feed.dart';
import 'package:nativechat/components/input_box_and_send_button.dart';
import 'package:nativechat/components/prompt_suggestions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:system_info2/system_info2.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

enum CustomFunctionCalls {
  getDeviceApps,
  getDeviceSpecs,
  getCallLogs,
  getSMS,
  getDeviceBattery,
  clearConversation
}

class _HomepageState extends State<Homepage> {
  TextEditingController userMessageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  late GenerativeModel model;
  var chatHistory = [];
  var callsLimit = 100;
  var smsLimit = 100;

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

  final functionDeclarations = [
    // SPECS
    FunctionDeclaration(
      CustomFunctionCalls.getDeviceSpecs.toString(),
      'Gets all information and dpecs about the device',
      Schema.object(properties: {
        'all': Schema.string(),
      }),
    ),

    // CALL LOGS
    FunctionDeclaration(
      CustomFunctionCalls.getCallLogs.toString(),
      'Gets a list call history with details about each message',
      Schema.object(properties: {
        'all': Schema.string(),
      }),
    ),

    // SMS
    FunctionDeclaration(
      CustomFunctionCalls.getSMS.toString(),
      "Gets a list of the user's text messages with details. It will also contain bank transactions and more.",
      Schema.object(properties: {
        'all': Schema.string(),
      }),
    ),

    // BATTERY
    FunctionDeclaration(
      CustomFunctionCalls.getDeviceBattery.toString(),
      "Gets the user device's battery level in percentage and if it is charging, connectedNotCharging, discharging, full or unknown.",
      Schema.object(properties: {
        'all': Schema.string(),
      }),
    ),

    // APPS
    FunctionDeclaration(
      CustomFunctionCalls.getDeviceApps.toString(),
      'Gets a count and list of all installed apps on the device.',
      Schema.object(properties: {
        'all': Schema.string(),
      }),
    ),

    // NO CONTEXT
    FunctionDeclaration(
      CustomFunctionCalls.clearConversation.toString(),
      'Clears the current conversation history.',
      Schema.object(
        properties: {'clear': Schema.string()},
      ),
    )
  ];

  var installedAppsString = '';
  var installedAppsLength = 0;
  Future<String> getDeviceApps() async {
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
    var advancedContext =
        "YOU HAVE $installedAppsLength APPS INSTALLED ON YOUR DEVICE AND HERE THEY ARE: $installedAppsString. NEVER LIST ALL THE APPS UNLESS SPECIFICALLY ASKED, IF ASKED ABOUT TIMESTAMPS CONVERT THEM TO HUMAN READABLE FORMATS.";

    return advancedContext;
  }

  Future<String> getDeviceSpecs() async {
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

    var advancedContext =
        "HERE IS THE DEVICE'S SYSTEM INFORMATION AND SPECS $systemInfo";

    return advancedContext;
  }

  Future<String> getCallLogs() async {
    // Ask Permissions
    await Permission.phone.request();
    await Permission.contacts.request();

    final callLogs = await CallLog.fetchCallLogs();

    var messageString = '';
    for (var eachCallLog in callLogs) {
      messageString +=
          'Name: ${eachCallLog.name.toString()} callType: ${eachCallLog.callType?.name} Number: ${eachCallLog.number} cachedNumberLabel:${eachCallLog.cachedNumberLabel.toString()} duration:${eachCallLog.duration} timestamp:${eachCallLog.timestamp.toString()} simDisplayName: ${eachCallLog.simDisplayName} \n';
    }

    var advancedContext =
        'YOUR LAST ${callLogs.length} CALL HISTORY: $messageString';

    return advancedContext;
  }

  Future<String> getSMS() async {
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

    var advancedContext = 'YOUR LAST $smsLimit SMS HISTORY: $messageString';
    return advancedContext;
  }

  Future<String> getDeviceBattery() async {
    // Get Battery Level and State
    var battery = Battery();
    var batteryLevel = await battery.batteryLevel;
    var batteryState = await battery.batteryState;

    var advancedContext =
        'THE BATTERY LEVEL IS $batteryLevel% AND IT IS ${batteryState.name}.';

    return advancedContext;
  }

  void chatWithAI() async {
    if (userMessageController.text.trim().isEmpty == false) {
      var userInput = userMessageController.text.trim();
      userMessageController.clear();
      addUserInputToChatHistory(userInput);
      setSystemMessage('getting response...');

      final chat = model.startChat(history: []);
      final content = Content.text(userInput);
      final response = await chat.sendMessage(content);

      if (response.functionCalls.isNotEmpty) {
        await functionCallHandler(userInput, response.functionCalls);
      } else {
        gotResponseFromAI(response.text);
        animateChatHistoryToBottom();
      }
    }
  }

  void addUserInputToChatHistory(userInput) {
    setState(() {
      chatHistory.add({
        "from": "user",
        "content": userInput,
      });
    });
  }

  void gotResponseFromAI(content) {
    setState(() {
      chatHistory.add({
        "from": "ai",
        "content": content,
      });
      chatHistory.removeAt(chatHistory.length - 2);
    });
  }

  var appFunctions = ['clearConversation'];
  Future<void> functionCallHandler(userInput, functionCalls) async {
    var advancedContext = '';
    for (var eachFunctionCall in functionCalls) {
      var functionCallName = eachFunctionCall.name;
      if (appFunctions.contains(functionCallName)) {
        if (functionCallName == 'clearConversation') {
          setSystemMessage('clearing conversation...');
          clearConversation();
        }
      } else {
        if (functionCallName == CustomFunctionCalls.getDeviceSpecs.toString()) {
          toggleContext(isDeviceInContext);
          setSystemMessage('getting device specs...');
          final deviceSpecs = await getDeviceSpecs();
          advancedContext += deviceSpecs;
        } else if (functionCallName ==
            CustomFunctionCalls.getDeviceApps.toString()) {
          toggleContext(areAppsInContext);
          setSystemMessage('getting installed apps...');
          final deviceApps = await getDeviceApps();
          advancedContext += deviceApps;
        } else if (functionCallName ==
            CustomFunctionCalls.getCallLogs.toString()) {
          toggleContext(areCallsInContext);
          setSystemMessage('getting call logs...');
          final callLogs = await getCallLogs();
          advancedContext += callLogs;
        } else if (functionCallName == CustomFunctionCalls.getSMS.toString()) {
          toggleContext(areMessagesInContext);
          setSystemMessage('getting text messages...');
          final sms = await getSMS();
          advancedContext += sms;
        } else if (functionCallName ==
            CustomFunctionCalls.getDeviceBattery.toString()) {
          toggleContext(isBatteryInContext);
          setSystemMessage('getting battery level and status...');
          print("hereb");
          final batteryInfo = await getDeviceBattery();
          advancedContext += batteryInfo;
          print("$advancedContext");
        }
      }
    }
    await continueFromFunctionCall(userInput, advancedContext);
  }

  Future<void> continueFromFunctionCall(userInput, context) async {
    final chat = model.startChat(history: []);
    final content = Content.text(
        "$userInput CONTEXT: $context. CHAT-HISTORY: $chatHistory");
    final response = await chat.sendMessage(content);
    gotResponseFromAI(response.text);
    animateChatHistoryToBottom();
  }

  void animateChatHistoryToBottom() {
    scrollController.animateTo(
      scrollController.position.extentTotal,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void setSystemMessage(systemMessage) {
    setState(() {
      if (chatHistory[chatHistory.length - 1]['from'] == 'system') {
        chatHistory.removeAt(chatHistory.length - 1);
      }
      chatHistory.add({
        "from": "system",
        "content": systemMessage.toString().trim().toLowerCase()
      });
    });
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
      addUserInputToChatHistory(userInput);
      final chat = model.startChat(history: []);
      final content = Content.text(userInput);
      final response = await chat.sendMessage(content);
      gotResponseFromAI(response.text);
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
      addUserInputToChatHistory(userInput);
      final chat = model.startChat(history: []);
      final content = Content.text(userInput);
      final response = await chat.sendMessage(content);
      gotResponseFromAI(response.text);
      animateChatHistoryToBottom();
    }
  }

  bool areMessagesInContext = false;
  bool areCallsInContext = false;
  bool isDeviceInContext = false;
  bool areAppsInContext = false;
  bool isBatteryInContext = false;
  bool isSummarizeInContext = false;

  void toggleSummarizeContext() {
    setState(() {
      isSummarizeInContext = !isSummarizeInContext;
    });
  }

  void toggleContext(variable) {
    setState(() {
      variable = !variable;
    });
  }

  void clearConversation() {
    setState(() {
      chatHistory = [];
      areCallsInContext = false;
      areMessagesInContext = false;
      isDeviceInContext = false;
      isSummarizeInContext = false;
    });
  }

  late StreamSubscription _intentDataStreamSubscription;
  List<SharedFile>? sharedList;
  @override
  void initState() {
    super.initState();
    chatHistory = [];
    model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: 'AIzaSyAnYR1BsRBqpCOk2taz51wwROcOF69L8oU',
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
      // systemInstruction: Content('ai', [TextPart(advancedContext)]),
      systemInstruction: Content('system', [
        TextPart(
            "YOU CAN DO AND TALK ABOUT ANYTHING! IF YOU THINK A FUNCTION CALL IS IMPORTANT BUT YOU CAN'T FIND THE FUNCTION IN YOUR CONTEXT YOU CAN SIMPLY TEXT GENERATE A POSSIBLE RESPONSE. YOU CAN ALSO WRITE ANY CODE.")
      ]),
      tools: [
        Tool(
          functionDeclarations: functionDeclarations,
        ),
      ],
      toolConfig: ToolConfig(
        functionCallingConfig: FunctionCallingConfig(
          mode: FunctionCallingMode.auto,
          // Options: 'AUTO', 'ANY', 'NONE'
          // 'AUTO': The model decides whether to respond with a function call or natural language
          // 'ANY': The model is constrained to always predict a function call. If allowedFunctionNames is provided, the model picks from the specified functions.
          // 'NONE': The model won't predict any function calls.
          // allowedFunctionNames: ['controlLight'], // Specify if mode is 'ANY'
        ),
      ),
    );

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
        actions: [
          IconButton(
            onPressed: () {
              clearConversation();
            },
            icon: Icon(
              Ionicons.trash_sharp,
              size: 18.0,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
      // Chat
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            chatHistory.isEmpty
                ? PromptSuggestionsFeed(
                    chatWithAI: chatWithAI,
                    userMessageController: userMessageController,
                  )
                : ConversationFeed(
                    scrollController: scrollController,
                    chatHistory: chatHistory,
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  // horizontal: 10.0,
                  // vertical: 10.0,
                  ),
              child: Column(
                spacing: 10.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ContextToggleRow(
                  //   areCallsInContext: areCallsInContext,
                  //   areMessagesInContext: areMessagesInContext,
                  //   isDeviceInContext: isDeviceInContext,
                  //   areAppsInContext: areAppsInContext,
                  //   isBatteryInContext: isBatteryInContext,
                  //   isSummarizeInContext: isSummarizeInContext,
                  //   toggleContext: toggleContext,
                  // ),
                  InputBoxAndSendButton(
                    summarizeText: summarizeText,
                    chatWithAI: chatWithAI,
                    isSummarizeInContext: isSummarizeInContext,
                    userMessageController: userMessageController,
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
