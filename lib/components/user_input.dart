import "package:flutter/material.dart";

class UserInput extends StatefulWidget {
  const UserInput({super.key, required this.text});

  final String text;

  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.78,
      margin: EdgeInsets.only(
        left: 15.0,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      // decoration: BoxDecoration(
      //   border: Border.all(
      //     color: Colors.grey[800]!,
      //   ),
      // ),
      child: Text(
        widget.text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
