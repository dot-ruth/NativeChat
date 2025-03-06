import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:theme_provider/theme_provider.dart';

class CircleDot extends StatefulWidget {
  const CircleDot({super.key, required this.leftPadding});

  final double leftPadding;

  @override
  State<CircleDot> createState() => _CircleDotState();
}

class _CircleDotState extends State<CircleDot> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: widget.leftPadding,
      ),
      child: Icon(
        Ionicons.ellipse,
        size: 18.0,
        color: ThemeProvider.themeOf(context).id == "light_theme"
            ? Colors.grey[400]
            : Colors.grey[800],
      ),
    );
  }
}
