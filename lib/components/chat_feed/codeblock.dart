// Dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/googlecode.dart';
import 'package:flutter_highlight/themes/hybrid.dart';
import 'package:flutter_highlight/themes/idea.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:flutter_highlight/themes/solarized-dark.dart';
import 'package:flutter_highlight/themes/solarized-light.dart';
import 'package:flutter_highlight/themes/tomorrow.dart';
import 'package:flutter_highlight/themes/vs.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:ionicons/ionicons.dart';
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
  int _currentThemeIndex = 0;

  // List of available syntax highlighting themes.
  final List<Map<String, dynamic>> _highlighterThemes = [
    {'name': 'vs2015', 'theme': vs2015Theme},
    {'name': 'monokaiSublime', 'theme': monokaiSublimeTheme},
    {'name': 'atomOneDark', 'theme': atomOneDarkTheme},
    {'name': 'github', 'theme': githubTheme},
    {'name': 'dracula', 'theme': draculaTheme},
    {'name': 'a11yDark', 'theme': a11yDarkTheme},
    {'name': 'atomOneLight', 'theme': atomOneLightTheme},
    {'name': 'googlecode', 'theme': googlecodeTheme},
    {'name': 'hybrid', 'theme': hybridTheme},
    {'name': 'idea', 'theme': ideaTheme},
    {'name': 'solarizedDark', 'theme': solarizedDarkTheme},
    {'name': 'solarizedLight', 'theme': solarizedLightTheme},
    {'name': 'tomorrow', 'theme': tomorrowTheme},
    {'name': 'vs', 'theme': vsTheme},
    {'name': 'monokai', 'theme': monokaiTheme},
  ];

  void copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() {
      _copied = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _copied = false;
    });
  }

  void changeTheme() {
    setState(() {
      _currentThemeIndex =
          (_currentThemeIndex + 1) % _highlighterThemes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ThemeProvider.themeOf(context).id == "light_theme"
          ? const Color(0xfff2f2f2)
          : const Color(0xff121212),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          Container(
            decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id == "light_theme"
                  ? Colors.grey[300]
                  : const Color(0xff151515),
              borderRadius: const BorderRadius.only(
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
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    color: ThemeProvider.themeOf(context).id == "light_theme"
                        ? Colors.black
                        : Colors.grey[700],
                  ),
                ),
                const Spacer(),

                GestureDetector(
                  onTap: changeTheme,
                  child: Icon(
                    Ionicons.color_palette,
                    size: 18,
                    color: ThemeProvider.themeOf(context).id == "light_theme"
                        ? Colors.grey[700]
                        : Colors.grey[500],
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: copyToClipboard,
                  child: Icon(
                    _copied ? Icons.done : Icons.content_paste,
                    size: 15,
                    color: _copied
                        ? ThemeProvider.themeOf(context).id == "light_theme"
                        ? Colors.green[600]
                        : Colors.greenAccent
                        : ThemeProvider.themeOf(context).id == "light_theme"
                        ? Colors.grey[700]
                        : Colors.grey[500],
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _collapse = !_collapse;
                    });
                  },
                  child: Icon(
                    _collapse
                        ? Icons.arrow_downward_outlined
                        : Icons.arrow_upward_outlined,
                    size: 18,
                    color: _collapse
                        ? ThemeProvider.themeOf(context).id == "light_theme"
                        ? Colors.green[600]
                        : Colors.greenAccent
                        : ThemeProvider.themeOf(context).id == "light_theme"
                        ? Colors.grey[700]
                        : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          // Code with Syntax Highlighting
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id == "light_theme"
                  ? const Color(0xfff2f2f2)
                  : const Color(0xff0e0e0e),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(10),
              child: HighlightView(
                widget.code,
                language: widget.name.isNotEmpty
                    ? widget.name.toLowerCase()
                    : 'plaintext',
                theme: _highlighterThemes[_currentThemeIndex]['theme'],
                padding: const EdgeInsets.all(12),
                textStyle: const TextStyle(
                  fontFamily: 'SourceCodePro',
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}