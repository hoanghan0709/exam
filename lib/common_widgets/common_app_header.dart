import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../gen/assets.gen.dart';

class CommonAppHeader extends StatefulWidget implements PreferredSizeWidget {
  const CommonAppHeader({
    super.key,
    this.leadingIcon,
    this.onBackPressed,
    this.title,
    this.centerTitle,
  });

  final Widget? leadingIcon;
  final String? title;
  final VoidCallback? onBackPressed;
  final bool? centerTitle;

  @override
  State<CommonAppHeader> createState() => _CommonAppHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);
}

class _CommonAppHeaderState extends State<CommonAppHeader> {
  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: widget.onBackPressed ?? () => Navigator.of(context).pop(),
      child: Transform.scale(scale: 1.2, child: Icon(Icons.arrow_back_ios, size: 18.h)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final leadingIcon = widget.leadingIcon;
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        height: kToolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.onBackPressed != null) Center(child: _buildBackButton(context)),
            if (widget.title != null)
              if (widget.centerTitle ?? false)
                Expanded(
                  child: Center(
                    child: Text(
                      widget.title!,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,)
                    ),
                  ),
                )
              else
                Text(widget.title!, style: TextStyle(fontSize: 18)),
            if (widget.leadingIcon != null) leadingIcon!,
          ],
        ),
      ),
    );
  }
}
