import 'package:flutter/material.dart';

class SystemContextButtons extends StatefulWidget {
  const SystemContextButtons({
    super.key,
    required this.state,
    required this.icon,
    required this.label,
    required this.toggleState,
  });

  final bool state;
  final IconData icon;
  final String label;
  final Function toggleState;

  @override
  State<SystemContextButtons> createState() => _SystemContextButtonsState();
}

class _SystemContextButtonsState extends State<SystemContextButtons> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        widget.toggleState(),
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          color: Color(0xff151515),
          border: Border.all(
            color: widget.state ? Colors.greenAccent : Colors.grey[900]!,
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Row(
          spacing: widget.state ? 6.0 : 0.0,
          children: [
            Icon(
              widget.icon,
              color: widget.state
                  ? Colors.greenAccent
                  : Theme.of(context).iconTheme.color,
              size: 20.0,
            ),
            widget.state
                ? Text(
                    widget.state ? widget.label : '',
                    style: TextStyle(
                      color: widget.state
                          ? Colors.greenAccent
                          : Theme.of(context).iconTheme.color,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
