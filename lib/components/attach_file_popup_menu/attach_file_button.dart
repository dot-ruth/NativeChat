import 'package:flutter/material.dart';

class AttachFileButton extends StatefulWidget {
  const AttachFileButton({super.key});

  @override
  State<AttachFileButton> createState() => _AttachFileButtonState();
}

class _AttachFileButtonState extends State<AttachFileButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 6.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).iconTheme.color!.withAlpha(100),
        ),
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.attach_file,
            color: Theme.of(context).iconTheme.color,
            size: 18.0,
          ),
          SizedBox(width: 6.0),
          Text(
            'Attach File',
            style: TextStyle(
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }
}
