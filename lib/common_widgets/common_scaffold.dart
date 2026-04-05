import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonScaffold extends StatefulWidget {
  const CommonScaffold({super.key, required this.body, this.appBar, this.resizeToAvoidBottomInset});

  final PreferredSizeWidget? appBar;

  final Widget body;
  final bool? resizeToAvoidBottomInset;

  @override
  State<CommonScaffold> createState() => _CommonScaffoldState();
}

class _CommonScaffoldState extends State<CommonScaffold> {
  @override
  Widget build(BuildContext context) {
    final body = widget.body;
    return Scaffold(
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset ?? false,
      appBar: widget.appBar,
      body: Padding(padding: EdgeInsets.symmetric(horizontal: 16.w), child: SafeArea(child: body)),
    );
  }
}
