import 'package:flutter/material.dart';
import 'package:nativechat/components/attach_file_popup_menu/attach_file_popup_menu.dart';
import 'package:theme_provider/theme_provider.dart';

class EachPopupMenuItem extends PopupMenuEntry<AttachmentOption> {
  const EachPopupMenuItem(
      {super.key,
      required this.attachmentOption,
      required this.icon,
      required this.title});

  final AttachmentOption attachmentOption;
  final IconData icon;
  final String title;

  @override
  double get height => kMinInteractiveDimension;

  @override
  bool represents(AttachmentOption? value) => value == attachmentOption;

  @override
  // ignore: library_private_types_in_public_api
  _EachPopupMenuItemState createState() => _EachPopupMenuItemState();
}

class _EachPopupMenuItemState extends State<EachPopupMenuItem> {
  @override
  Widget build(BuildContext context) {
    var color = ThemeProvider.themeOf(context).id == "light_theme"
        ? Colors.black
        : Colors.white;
    return PopupMenuItem<AttachmentOption>(
      value: widget.attachmentOption,
      padding: const EdgeInsets.symmetric(
        horizontal: 18.0,
      ),
      child: ListTile(
        leading: Icon(
          widget.icon,
          size: 20.0,
          color: color,
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: color,
          ),
        ),
      ),
    );
  }
}
