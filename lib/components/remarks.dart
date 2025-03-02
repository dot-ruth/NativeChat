import 'package:flutter/material.dart';
import 'package:nativechat/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Remarks extends StatefulWidget {
  const Remarks({super.key});

  @override
  State<Remarks> createState() => _RemarksState();
}

class _RemarksState extends State<Remarks> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        bottom: 100.0,
      ),
      child: Column(
        spacing: 30.0,
        children: [
          Image.asset(
            'assets/logo/logoBorder.png',
            height: 80.0,
          ),
          Text(
            "This uses Gemini 2.0 Flash from google with a 1 million token context window. You can get a free api key from their website which will be sufficient for most of your tasks. \n\nRemember that using the free version lets google access your conversation history and private information to further improve their model. So if you'd like a private version please consider switching to a paid tier which also has higher rates.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600]!,
            ),
          ),
          GestureDetector(
            onTap: () async {
              // Open the project source code in a browser
              await launchUrl(Uri.parse(github));
            },
            child: Text(
              "This project is free and open source. Click here to star, contribute or view the project source code.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
