import 'package:exam/export.dart';
import 'package:flutter/material.dart';

class CommonScaffold extends StatefulWidget {
  const CommonScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.resizeToAvoidBottomInset,
    this.bottomNavigationBar = const SizedBox(),
    this.extendBody = false,
    this.horizontalPadding,
  });

  final PreferredSizeWidget? appBar;
  final bool extendBody;
  final Widget body;
  final Widget bottomNavigationBar;
  final bool? resizeToAvoidBottomInset;
  final double? horizontalPadding;

  @override
  State<CommonScaffold> createState() => _CommonScaffoldState();
}

class _CommonScaffoldState extends State<CommonScaffold> {
  @override
  Widget build(BuildContext context) {
    final body = widget.body;
    return Scaffold(
      extendBody: widget.extendBody,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset ?? false,
      appBar: widget.appBar,
      bottomNavigationBar: widget.bottomNavigationBar,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding?.w ?? 16.w),
          child: body,
        ),
      ),
    );
  }
}
