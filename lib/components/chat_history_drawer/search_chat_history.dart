import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class SearchChatHistory extends StatefulWidget {
  const SearchChatHistory(
      {super.key,
      required this.searchController,
      required this.onSearchChanged});

  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  @override
  State<SearchChatHistory> createState() => _SearchChatHistoryState();
}

class _SearchChatHistoryState extends State<SearchChatHistory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5.0, bottom: 20.0),
      child: TextField(
        controller: widget.searchController,
        onChanged: widget.onSearchChanged,
        cursorColor: ThemeProvider.themeOf(context).id == "light_theme"
            ? Colors.black
            : Colors.white,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 10.0, left: 15.0),
          // prefixIcon: Icon(
          //   Icons.search,
          //   size: 20.0,
          //   color: ThemeProvider.themeOf(context).id == "light_theme"
          //       ? Colors.grey[600]
          //       : Colors.grey[400],
          // ),
          hintText: "Search chats",
          hintStyle: TextStyle(
            color: ThemeProvider.themeOf(context).id == "light_theme"
                ? Colors.grey[600]
                : Colors.grey[500],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: ThemeProvider.themeOf(context).id == "light_theme"
              ? Colors.grey[100]
              : Colors.grey[900],
        ),
        style: TextStyle(
          color: ThemeProvider.themeOf(context).id == "light_theme"
              ? Colors.black
              : Colors.white,
        ),
      ),
    );
  }
}
