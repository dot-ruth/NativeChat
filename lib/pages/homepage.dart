import 'dart:async';

import 'package:flutter/material.dart';
import 'package:call_log_new/call_log_new.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive/hive.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nativechat/components/conversation_feed.dart';
import 'package:nativechat/components/input_box.dart';
import 'package:nativechat/components/prompt_suggestions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:system_info2/system_info2.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
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
      "getDeviceSpecs",
      "Gets all system specifications and hardware details about the device.",
      Schema.object(properties: {
        'kernelArchitecture': Schema.string(
            description:
                "The architecture of the device's kernel (e.g., x86_64, arm64)."),
        'kernelBitness': Schema.integer(
            description: "The bitness of the kernel (e.g., 32 or 64)."),
        'kernelName': Schema.string(
            description:
                "The name of the kernel (e.g., Linux, Darwin, Windows)."),
        'kernelVersion': Schema.string(
            description: "The version of the kernel installed on the device."),
        'operatingSystemName': Schema.string(
            description:
                "The name of the operating system running on the device."),
        'operatingSystemVersion': Schema.string(
            description:
                "The version of the operating system installed on the device."),
        'userDirectory': Schema.string(
            description: "The home directory path of the current user."),
        'userId': Schema.string(
            description: "The user ID of the currently logged-in user."),
        'userName': Schema.string(
            description: "The username of the currently logged-in user."),
        'userSpaceBitness': Schema.integer(
            description: "The bitness of the user space (e.g., 32 or 64)."),
        'totalPhysicalMemoryMB': Schema.integer(
            description: "Total amount of physical memory (RAM) in megabytes."),
        'freePhysicalMemoryMB': Schema.integer(
            description: "Available physical memory (RAM) in megabytes."),
        'totalVirtualMemoryMB': Schema.integer(
            description: "Total virtual memory size in megabytes."),
        'freeVirtualMemoryMB': Schema.integer(
            description: "Available virtual memory in megabytes."),
        'virtualMemorySizeMB': Schema.integer(
            description: "The size of allocated virtual memory in megabytes."),
        'numberOfProcessors': Schema.integer(
            description: "The number of processor cores available."),
        'coresInfo': Schema.array(
            items: Schema.string(
                description: "Details about each processor core.")),
      }),
    ),

    // CALL LOGS
    FunctionDeclaration(
      "getCallLogs",
      'Gets a list call history with details about each message. Which you can use to do more inference and statistics from.',
      Schema.object(properties: {
        'callLogs': Schema.array(
          items: Schema.object(properties: {
            'name': Schema.string(
                description:
                    "The contact name associated with the call, if available."),
            'callType': Schema.string(
                description:
                    "The type of call: incoming, outgoing, or missed."),
            'number': Schema.string(
                description: "The phone number associated with the call."),
            'cachedNumberLabel': Schema.string(
                description: "The cached label for the number, if available."),
            'duration': Schema.integer(
                description: "The duration of the call in seconds."),
            'timestamp': Schema.string(
                description: "The timestamp of the call in ISO 8601 format."),
            'simDisplayName': Schema.string(
                description: "The name of the SIM card used for the call."),
          }),
        ),
      }),
    ),

    // SMS
    FunctionDeclaration(
      "getSMS",
      "Gets a list of the user's text messages with details, including sender, content, date, and whether the message was read. This list could contain private, work, transactional, bank, ISP, financial and many more information that can be used for further analysis and statistics.",
      Schema.object(properties: {
        'messages': Schema.array(
          items: Schema.object(properties: {
            'id': Schema.string(
                description: "A unique identifier for the message."),
            'from': Schema.string(
                description: "The sender's phone number or contact name."),
            'content':
                Schema.string(description: "The body of the text message."),
            'date': Schema.string(
                description:
                    "The timestamp when the message was sent or received, in ISO 8601 format."),
            'isRead': Schema.boolean(
                description:
                    "Indicates whether the message has been read (true) or not (false)."),
            'kind': Schema.string(
                description:
                    "Specifies if the message was 'Sent' or 'Received'."),
          }),
        ),
      }),
    ),

    // BATTERY
    FunctionDeclaration(
      "getDeviceBattery",
      "Gets the user's device battery level in percentage and its charging state.",
      Schema.object(properties: {
        'batteryLevel': Schema.integer(
            description: "The current battery level as a percentage (0-100)."),
        'batteryState': Schema.string(
            description:
                "The current state of the battery: charging, discharging, full, connectedNotCharging, or unknown."),
      }),
    ),

    // APPS
    FunctionDeclaration(
      "getDeviceApps",
      "Gets a count and list of all installed apps on the device. Use this function to check if a specific app is installed by searching for it in the returned list.",
      Schema.object(properties: {
        'installedApps': Schema.array(
          items: Schema.object(properties: {
            'appName': Schema.string(
                description: "The display name of the installed application."),
            'packageName': Schema.string(
                description:
                    "The unique package identifier of the application."),
            'versionName': Schema.string(
                description:
                    "The human-readable version name of the application."),
            'versionCode': Schema.integer(
                description: "The internal version code of the application."),
            'installedTimestamp': Schema.string(
                description:
                    "The timestamp of when the application was installed, in ISO 8601 format."),
          }),
        ),
      }),
    ),

    // NO CONTEXT
    FunctionDeclaration(
      "clearConversation",
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
        if (response.text.toString().trim() != 'null') {
          gotResponseFromAI(response.text);
          animateChatHistoryToBottom();
        }
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
    if (isInVoiceMode) {
      speak(content);
    }
    setState(() {
      chatHistory.add({
        "from": "ai",
        "content": content,
      });
      chatHistory.removeAt(chatHistory.length - 2);
    });
  }

  FlutterTts flutterTts = FlutterTts();
  void speak(message) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.8);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(0.7);
    await flutterTts.speak(message);
  }

  var appFunctions = ['clearConversation'];
  Future<void> functionCallHandler(userInput, functionCalls) async {
    var advancedContext = '';
    for (var eachFunctionCall in functionCalls) {
      var functionCallName = eachFunctionCall.name.toString().trim();

      if (appFunctions.contains(functionCallName)) {
        if (functionCallName == 'clearConversation') {
          clearConversation();
        }
      } else {
        if (functionCallName == "getDeviceSpecs") {
          toggleContext(isDeviceInContext);
          setSystemMessage('getting device specs...');
          final deviceSpecs = await getDeviceSpecs();
          advancedContext += deviceSpecs;
        } else if (functionCallName == "getDeviceApps") {
          toggleContext(areAppsInContext);
          setSystemMessage('getting installed apps...');
          final deviceApps = await getDeviceApps();
          advancedContext += deviceApps;
        } else if (functionCallName == "getCallLogs") {
          toggleContext(areCallsInContext);
          setSystemMessage('getting call logs...');
          final callLogs = await getCallLogs();
          advancedContext += callLogs;
        } else if (functionCallName == "getSMS") {
          toggleContext(areMessagesInContext);
          setSystemMessage('getting text messages...');
          final sms = await getSMS();
          advancedContext += sms;
        } else if (functionCallName == "getDeviceBattery") {
          toggleContext(isBatteryInContext);
          setSystemMessage('getting battery level and status...');
          final batteryInfo = await getDeviceBattery();
          advancedContext += batteryInfo;
        }
        await continueFromFunctionCall(userInput, advancedContext);
      }
    }
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
    });
  }

  dynamic isOneSidedChatMode = false;
  void toggleOneSidedChatMode() async {
    Box settingBox = await Hive.openBox("settings");
    isOneSidedChatMode = await settingBox.get("isOneSidedChatMode");
    if (isOneSidedChatMode.toString() == 'null') {
      await settingBox.put("isOneSidedChatMode", false);
      isOneSidedChatMode = false;
    }

    setState(() {
      isOneSidedChatMode = !isOneSidedChatMode;
    });
    await settingBox.put("isOneSidedChatMode", isOneSidedChatMode);
    Hive.close();
  }

  void getSettings() async {
    Box settingBox = await Hive.openBox("settings");
    isOneSidedChatMode = await settingBox.get("isOneSidedChatMode");
    if (isOneSidedChatMode.toString() == 'null') {
      await settingBox.put("isOneSidedChatMode", false);
      isOneSidedChatMode = false;
    }
    Hive.close();
  }

  final SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';
  void initSpeech() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  bool isInVoiceMode = false;
  void toggleVoiceMode() async {
    setState(() {
      isInVoiceMode = !isInVoiceMode;
    });
    if (isInVoiceMode == false) {
      await flutterTts.stop();
    }
  }

  void startListening() async {
    await flutterTts.stop();
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  void stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      userMessageController.text = lastWords;
    });
    if (speechToText.isNotListening) {
      chatWithAI();
    }
  }

  late StreamSubscription _intentDataStreamSubscription;
  List<SharedFile>? sharedList;
  @override
  void initState() {
    super.initState();
    chatHistory = [];
    initSpeech();
    getSettings();

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
            "YOU ARE A HELPFUL ASSISTANT IN THE USER'S PHONE. YOU GET ACCESS TO DIFFERENT INFORMATION BY THE FUNCTION CALLS PROVIDED TO YOU. YOU CAN DO AND TALK ABOUT ANYTHING! ALWAYS USE THE AVAILABLE FUNCTION CALLS FIRST BEFORE TEXT-GENERATING. IF YOU THINK A FUNCTION CALL IS IMPORTANT BUT YOU CAN'T FIND THE FUNCTION IN YOUR CONTEXT YOU CAN SIMPLY TEXT GENERATE A POSSIBLE RESPONSE. YOU CAN ALSO WRITE ANY CODE.")
      ]),
      tools: [
        Tool(
          functionDeclarations: functionDeclarations,
        ),
      ],
      toolConfig: ToolConfig(
        functionCallingConfig: FunctionCallingConfig(
          mode: FunctionCallingMode.auto,
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
        leading: // Change chat layout
            IconButton(
          onPressed: () async {
            toggleOneSidedChatMode();
          },
          icon: Icon(
            isOneSidedChatMode == true
                ? Icons.align_horizontal_right_outlined
                : Icons.align_horizontal_left_outlined,
          ),
        ),
        actions: [
          // Clear Chat
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
                    isOneSidedChatMode: isOneSidedChatMode,
                  )
                : ConversationFeed(
                    scrollController: scrollController,
                    chatHistory: chatHistory,
                    isOneSidedChatMode: isOneSidedChatMode,
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
                  InputBoxAndSendButton(
                    summarizeText: summarizeText,
                    chatWithAI: chatWithAI,
                    isSummarizeInContext: isSummarizeInContext,
                    userMessageController: userMessageController,
                    startListening: startListening,
                    stopListening: stopListening,
                    speechToText: speechToText,
                    toggleVoiceMode: toggleVoiceMode,
                    isInVoiceMode: isInVoiceMode,
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
