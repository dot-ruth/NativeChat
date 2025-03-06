import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CircleLoadingAnimation extends StatefulWidget {
  const CircleLoadingAnimation({super.key});

  @override
  State<CircleLoadingAnimation> createState() => _CircleLoadingAnimationState();
}

class _CircleLoadingAnimationState extends State<CircleLoadingAnimation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 18.0),
      child: LoadingAnimationWidget.beat(
        color: Colors.grey[600]!,
        size: 14,
      ),
    );
  }
}
