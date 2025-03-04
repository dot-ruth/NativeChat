import 'dart:async';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive/hive.dart';
import 'package:nativechat/components/apikey_input.dart';
import 'package:nativechat/components/conversation_feed.dart';
import 'package:nativechat/components/home_appbar.dart';
import 'package:nativechat/components/input_box.dart';
import 'package:nativechat/components/prompt_suggestions.dart';
import 'package:nativechat/components/remarks.dart';
import 'package:nativechat/constants/constants.dart';
import 'package:nativechat/utils/get_device_context.dart';
import 'package:nativechat/utils/tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
  bool _loading = false;
  var installedAppsString = '';
  var installedAppsLength = 0;
  Uint8List? attachedImageBytes;
  String? attachedMime;

  Future<void> _sendImageFilePrompt() async {
    setState(() {
      _loading = true;
    });
    try {
      // Pick an image file.
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result == null || result.files.isEmpty) {
        setState(() {
          _loading = false;
        });
        return;
      }
      attachedImageBytes = result.files.first.bytes;
      attachedMime = result.files.first.extension?.toLowerCase() == 'png'
          ? 'image/png'
          : 'image/jpeg';

      setState(() {
        chatHistory.add({
          "from": "user",
          "content": "",
          "image": attachedImageBytes,
        });
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      // Handle error as needed.
    }
  }

// Updated chatWithAI method to check for attached image data.
// If present, compose a multi-part message using both prompt and image.
  void chatWithAI() async {
    if (userMessageController.text.trim().isNotEmpty) {
      var userInput = userMessageController.text.trim();
      userMessageController.clear();
      addUserInputToChatHistory(userInput);
      setSystemMessage('getting response...');

      final chat = model.startChat(history: []);
      Content content;

      // Check if an image is attached.
      if (attachedImageBytes != null && attachedMime != null) {
        // Create multi-part content with text and image.
        content = Content.multi([
          TextPart(userInput),
          DataPart(attachedMime!, attachedImageBytes!),
        ]);
        // Reset the attached image data after sending.
        attachedImageBytes = null;
        attachedMime = null;
      } else {
        content = Content.text('$userInput CONTEXT: $chatHistory');
      }

      try {
        final response = await chat.sendMessage(content);
        if (response.functionCalls.isNotEmpty) {
          await functionCallHandler(userInput, response.functionCalls);
        } else {
          if (response.text.toString().trim() != 'null') {
            gotResponseFromAI(response.text);
            animateChatHistoryToBottom();
          }
        }
      } catch (e) {
        setSystemMessage(e, isError: true);
        if (isInVoiceMode) {
          speak(e.toString());
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
        if (functionCallName == "getDeviceTime") {
          setSystemMessage('getting device time...');
          final deviceTime = await getDeviceTime();
          advancedContext += deviceTime;
        } else if (functionCallName == "getDeviceSpecs") {
          setSystemMessage('getting device specs...');
          final deviceSpecs = await getDeviceSpecs();
          advancedContext += deviceSpecs;
        } else if (functionCallName == "getDeviceApps") {
          setSystemMessage('getting installed apps...');
          final deviceApps =
              await getDeviceApps(installedAppsLength, installedAppsString);
          advancedContext += deviceApps;
        } else if (functionCallName == "getCallLogs") {
          setSystemMessage('getting call logs...');
          final callLogs = await getCallLogs();
          advancedContext += callLogs;
        } else if (functionCallName == "getSMS") {
          setSystemMessage('getting text messages...');
          final sms = await getSMS();
          advancedContext += sms;
        } else if (functionCallName == "getDeviceBattery") {
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
        "$userInput CONTEXT: $context. CHAT-HISTORY: ${chatHistory.toString()}");

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

  void setSystemMessage(
    systemMessage, {
    isError = false,
  }) {
    setState(() {
      if (chatHistory[chatHistory.length - 1]['from'] == 'system') {
        chatHistory.removeAt(chatHistory.length - 1);
      }
      chatHistory.add({
        "from": "system",
        "content": systemMessage.toString().trim().toLowerCase(),
        "isError": isError,
      });
    });
  }

  void summarizeText({fromUserInput = false}) async {
    final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
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
      setState(() {
        chatHistory.add({
          "from": "ai",
          "content": response.text,
        });
      });
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

  void clearConversation() {
    setState(() {
      chatHistory = [];
    });
  }

  dynamic isOneSidedChatMode = true;
  void toggleOneSidedChatMode() async {
    Box settingBox = await Hive.openBox("settings");
    isOneSidedChatMode = await settingBox.get("isOneSidedChatMode") ?? true;

    setState(() {
      isOneSidedChatMode = !isOneSidedChatMode;
    });
    await settingBox.put("isOneSidedChatMode", isOneSidedChatMode);
    Hive.close();
  }

  final SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';

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
    speak("", stopSpeaking: true);
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

  String apiKey = '';
  bool isAddingAPIKey = false;
  TextEditingController apiKeyController = TextEditingController();

  Future<void> getSettings() async {
    // Is One Sided Chat Mode
    Box settingBox = await Hive.openBox("settings");
    isOneSidedChatMode = await settingBox.get("isOneSidedChatMode") ?? true;

    // Get API Key
    apiKey = await settingBox.get("apikey") ?? "";
    if (apiKey == "") {
      isAddingAPIKey = true;
    } else {
      isAddingAPIKey = false;
    }
    setState(() {});

    // Close
    await Hive.close();

    // Model Initialization
    modelInitialization();
  }

  void modelInitialization() {
    // Model
    model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
      // systemInstruction: Content('ai', [TextPart(advancedContext)]),
      systemInstruction: Content('system', [TextPart(systemPrompt)]),
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
  }

  void initializations() async {
    // Clear Chat
    chatHistory = [];

    // Get Preferences
    await getSettings();

    // Init TTS
    await speechToText.initialize();

    // Get Shared Files
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

  late StreamSubscription _intentDataStreamSubscription;
  List<SharedFile>? sharedList;
  @override
  void initState() {
    super.initState();
    initializations();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppbar(
        toggleAPIKey: () {
          setState(() {
            isAddingAPIKey = !isAddingAPIKey;
          });
        },
        toggleOneSidedChatMode: toggleOneSidedChatMode,
        isOneSidedChatMode: isOneSidedChatMode,
        clearConversation: clearConversation,
      ),
      // Chat
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          isAddingAPIKey == true
              ? Remarks()
              : chatHistory.isEmpty
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
          Column(
            spacing: 10.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isAddingAPIKey == true
                  ? APIKeyInput(
                      getSettings: getSettings,
                    )
                  : InputBox(
                      attachFile: _sendImageFilePrompt,
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
        ],
      ),
    );
  }
}
