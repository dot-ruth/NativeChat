import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nativechat/components/system_context_buttons.dart';

class ContextToggleRow extends StatefulWidget {
  const ContextToggleRow({
    super.key,
    required this.areCallsInContext,
    required this.areMessagesInContext,
    required this.isDeviceInContext,
    required this.areAppsInContext,
    required this.isBatteryInContext,
    required this.isSummarizeInContext,
    required this.toggleContext,
  });

  final bool areCallsInContext;
  final bool areMessagesInContext;
  final bool isDeviceInContext;
  final bool areAppsInContext;
  final bool isBatteryInContext;
  final bool isSummarizeInContext;
  final Function toggleContext;

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
            toggleState: widget.toggleContext,
          ),
          SystemContextButtons(
            state: widget.areMessagesInContext,
            icon: Ionicons.mail_outline,
            label: 'Messages',
            toggleState: widget.toggleContext,
          ),
          SystemContextButtons(
            state: widget.isDeviceInContext,
            icon: Ionicons.hardware_chip_outline,
            label: 'Device',
            toggleState: widget.toggleContext,
          ),
          SystemContextButtons(
            state: widget.areAppsInContext,
            icon: Ionicons.apps_outline,
            label: 'Apps',
            toggleState: widget.toggleContext,
          ),
          SystemContextButtons(
            state: widget.isBatteryInContext,
            icon: Ionicons.battery_half_outline,
            label: 'Battery',
            toggleState: widget.toggleContext,
          ),
          SystemContextButtons(
            state: widget.isSummarizeInContext,
            icon: Ionicons.pencil_outline,
            label: 'Summarize',
            toggleState: widget.toggleContext,
          ),
        ],
      ),
    );
  }
}
