import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nativechat/components/system_context_buttons.dart';

class ContextToggleRow extends StatefulWidget {
  const ContextToggleRow({
    super.key,
    required this.areCallsInContext,
    required this.areMessagesInContext,
    required this.isDeviceInContext,
    required this.isSummarizeInContext,
    required this.toggleCallsContext,
    required this.toggleMessageContext,
    required this.toggleDeviceContext,
    required this.toggleSummarizeContext,
  });

  final bool areCallsInContext;
  final bool areMessagesInContext;
  final bool isDeviceInContext;
  final bool isSummarizeInContext;
  final Function toggleCallsContext;
  final Function toggleMessageContext;
  final Function toggleDeviceContext;
  final Function toggleSummarizeContext;

  @override
  State<ContextToggleRow> createState() => _ContextToggleRowState();
}

class _ContextToggleRowState extends State<ContextToggleRow> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 6.0,
        children: [
          SizedBox(width: 5.0),
          SystemContextButtons(
            state: widget.areCallsInContext,
            icon: Ionicons.call_outline,
            label: 'Calls',
            toggleState: widget.toggleCallsContext,
          ),
          SystemContextButtons(
            state: widget.areMessagesInContext,
            icon: Ionicons.mail_outline,
            label: 'Messages',
            toggleState: widget.toggleMessageContext,
          ),
          SystemContextButtons(
            state: widget.isDeviceInContext,
            icon: Ionicons.hardware_chip_outline,
            label: 'Device',
            toggleState: widget.toggleDeviceContext,
          ),
          SystemContextButtons(
            state: widget.isSummarizeInContext,
            icon: Ionicons.pencil_outline,
            label: 'Summarize',
            toggleState: widget.toggleSummarizeContext,
          ),
        ],
      ),
    );
  }
}
