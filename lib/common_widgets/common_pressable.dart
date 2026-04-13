import 'package:flutter/material.dart';

class PressableWidget extends StatelessWidget {
  const PressableWidget({
    super.key,
    this.onPressed,
    required this.child,
    this.padding = 8.0,
    this.height,
    this.width,
    this.backgroundColor,
    // this.label,
    this.labelStyle,
  });

  final VoidCallback? onPressed;
  final Widget? child;
  final double padding;
  final double? height;
  final double? width;
  // final String? label;
  final TextStyle? labelStyle;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: child,
      // : Row(mainAxisSize: MainAxisSize.min, children: [child ?? const SizedBox.shrink()]),
    );
  }
}
