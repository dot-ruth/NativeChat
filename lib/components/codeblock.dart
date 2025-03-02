import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Codeblock extends StatefulWidget {
  const Codeblock({super.key, required this.code, required this.name});

  final String code;
  final String name;

  @override
  State<Codeblock> createState() => _CodeblockState();
}

class _CodeblockState extends State<Codeblock> {
  var _copied = false;
  var _collapse = false;

  void copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.code)).then((value) {
      setState(() {
        _copied = true;
      });
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _copied = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xff121212),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name and Copy Button
          Container(
            decoration: BoxDecoration(
              color: Color(0xff151515),
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            padding: const EdgeInsets.only(
              left: 14.0,
              right: 10.0,
              top: 6.0,
              bottom: 6.0,
            ),
            child: Row(
              spacing: 8.0,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: copyToClipboard,
                  child: Icon(
                    (_copied) ? Icons.done : Icons.content_paste,
                    size: 15,
                    color: (_copied) ? Colors.greenAccent : Colors.grey[500],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _collapse = !_collapse;
                    });
                  },
                  child: Icon(
                    (_collapse)
                        ? Icons.arrow_downward_outlined
                        : Icons.arrow_upward_outlined,
                    size: 15,
                    color: (_collapse) ? Colors.greenAccent : Colors.grey[500],
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey[900]!,
          ),

          // Code
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(10),
            child: Text(
              widget.code,
              maxLines: _collapse ? 5 : null,
              style: TextStyle(
                color: Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
