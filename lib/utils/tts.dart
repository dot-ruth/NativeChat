import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();
void speak(message, {stopSpeaking = false}) async {
  if (stopSpeaking) {
    await flutterTts.stop();
  } else {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.8);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(0.7);
    await flutterTts.speak(message.toString());
  }
}
