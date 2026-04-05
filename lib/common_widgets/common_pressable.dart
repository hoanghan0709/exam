import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PressableWidget extends StatelessWidget {
  const PressableWidget({
    super.key,
    this.onPressed,
    this.child,
    this.padding = 8.0,
    this.height = 50.0,
    this.width = 140.0,
    this.backgroundColor,
    this.label,
    this.labelStyle,
  });

  final VoidCallback? onPressed;
  final Widget? child;
  final double padding;
  final double height;
  final double width;
  final String? label;
  final TextStyle? labelStyle;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: backgroundColor),
        height: height,
        width: width,
        padding: EdgeInsets.all(padding),
        child:
            label != null
                ? Text(
                  label!,
                  style:
                      labelStyle ??
                      TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w500),
                )
                : Row( mainAxisSize: MainAxisSize.min,children: [child ?? const SizedBox.shrink()]),
      ),
    );
  }
}
