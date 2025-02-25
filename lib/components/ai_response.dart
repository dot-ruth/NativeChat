import "package:flutter/material.dart";
import "package:ionicons/ionicons.dart";
import "package:nativechat/components/dashed_border_exracted.dart";

class AIResponse extends StatefulWidget {
  const AIResponse({super.key, required this.text, this.isLast = false});

  final String text;
  final bool isLast;

  @override
  State<AIResponse> createState() => _AIResponseState();
}

class _AIResponseState extends State<AIResponse> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.85,
          margin: EdgeInsets.only(
            left: 40.0,
          ),
          padding: EdgeInsets.only(
            top: 10.0,
            bottom: 25.0,
          ),
          decoration: BoxDecoration(
            border: dashedBorderExtracted,
          ),
          child: Container(
            margin: EdgeInsets.only(
              left: 12.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 8.0,
              // vertical: 5.0,
            ),
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: Colors.grey[800]!,
            //   ),
            // ),
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: Colors.grey[800]!,
            //   ),
            // ),
            child: Text(
              widget.text,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ),
        ),
        widget.isLast == true
            ? Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(
                  left: 31.0,
                ),
                child: Icon(
                  Ionicons.ellipse,
                  size: 18.0,
                  color: Colors.grey[900],
                ),
              )
            : Container(),
      ],
    );
  }
}
