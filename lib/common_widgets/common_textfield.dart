import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonTextField extends StatefulWidget {
  const CommonTextField({
    super.key,
    this.hint,
    this.inputDecoration,
    this.focusDecoration,
    this.errorDecoration,
    this.controller,
    this.onTap,
    this.label,
    this.filled,
    this.colorFilled,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText,
    this.onTapSuffixIcon,
  });

  final String? label;
  final Widget? hint;
  final InputDecoration? inputDecoration;
  final InputBorder? focusDecoration;
  final InputBorder? errorDecoration;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final bool? filled;
  final Color? colorFilled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTapSuffixIcon;
  final bool? obscureText;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 4.h,
      children: [
        Text(widget.label ?? ''),
        Flexible(
          child: TextFormField(
            cursorHeight: 20,
            obscureText: widget.obscureText ?? false,
            controller: widget.controller,
            decoration:
                widget.inputDecoration ??
                InputDecoration(

                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.suffixIcon,
                  contentPadding: EdgeInsets.only(left: 8.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  filled: widget.filled,
                  hint: widget.hint,
                  fillColor: widget.colorFilled,
                  errorBorder: widget.errorDecoration,
                  focusedBorder: widget.focusDecoration,
                ),

            onTap: widget.onTap,
          ),
        ),
      ],
    );
  }
}
