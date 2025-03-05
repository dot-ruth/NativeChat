import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:theme_provider/theme_provider.dart';

class HomeAppbar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppbar({
    super.key,
    required this.toggleAPIKey,
    required this.toggleOneSidedChatMode,
    required this.clearConversation,
    required this.isOneSidedChatMode,
  });

  final VoidCallback toggleAPIKey;
  final VoidCallback toggleOneSidedChatMode;
  final VoidCallback clearConversation;
  final bool isOneSidedChatMode;

  @override
  State<HomeAppbar> createState() => _HomeAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _HomeAppbarState extends State<HomeAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        // API Key
        IconButton(
          onPressed: widget.toggleAPIKey,
          icon: Icon(
            Ionicons.key_sharp,
            size: 18.0,
            color: Theme.of(context).iconTheme.color,
          ),
        ),

        //Change Theme
        IconButton(
            onPressed: () {
              ThemeProvider.controllerOf(context).nextTheme();
            },
            icon: Icon(
              ThemeProvider.themeOf(context).id == "light_theme" ? Icons.dark_mode_outlined : Icons.wb_sunny_outlined,
              size: 20.0,
              color: Theme.of(context).iconTheme.color
            ),
          ),

        // Change chat layout
        IconButton(
          onPressed: widget.toggleOneSidedChatMode,
          icon: Icon(
            widget.isOneSidedChatMode == true
                ? Icons.align_horizontal_right_outlined
                : Icons.align_horizontal_left_outlined,
            size: 20.0,
            color: Theme.of(context).iconTheme.color,
          ),
        ),

        // Clear Chat
        IconButton(
          onPressed: widget.clearConversation,
          icon: Icon(
            Ionicons.trash_sharp,
            size: 18.0,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ],
    );
  }
}
