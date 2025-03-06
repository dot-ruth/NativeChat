import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme_provider/theme_provider.dart';

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
      color: ThemeProvider.themeOf(context).id == "light_theme"
          ? const Color(0xfff2f2f2)
          : Color(0xff121212),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name, Copy and Fold Button
          Container(
            decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id == "light_theme"
                  ? Colors.grey[300]
                  : Color(0xff151515),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
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
                      color: ThemeProvider.themeOf(context).id == "light_theme"
                          ? Colors.black
                          : Colors.grey[700]),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: copyToClipboard,
                  child: Icon(
                    (_copied) ? Icons.done : Icons.content_paste,
                    size: 15,
                    color: (_copied)
                        ? ThemeProvider.themeOf(context).id == "light_theme"
                            ? Colors.green[600]
                            : Colors.greenAccent
                        : ThemeProvider.themeOf(context).id == "light_theme"
                            ? Colors.grey[700]
                            : Colors.grey[500],
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
                    size: 18,
                    color: (_collapse)
                        ? ThemeProvider.themeOf(context).id == "light_theme"
                            ? Colors.green[600]
                            : Colors.greenAccent
                        : ThemeProvider.themeOf(context).id == "light_theme"
                            ? Colors.grey[700]
                            : Colors.grey[500],
                  ),
                )
              ],
            ),
          ),

          // Code
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id == "light_theme"
                  ? const Color(0xfff2f2f2)
                  : Color(0xff0e0e0e),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            //color: ThemeProvider.themeOf(context).id == "light_theme" ? const Color(0xfff2f2f2) :  Colors.grey[900]!,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.code,
                maxLines: _collapse ? 5 : null,
                style: TextStyle(
                  color: ThemeProvider.themeOf(context).id == "light_theme"
                      ? Colors.black
                      : Colors.grey[400],
                  // fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
