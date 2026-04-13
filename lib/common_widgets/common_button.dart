import 'package:exam/export.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = 8.0,
    this.height,
    this.width,
    this.backgroundColor,
    this.labelStyle,
    this.radius,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final double padding;
  final double? height;
  final double? width;
  final double? radius;
  final TextStyle? labelStyle;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return PressableWidget(
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.all(padding),
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor ?? context.colors.primary,
          borderRadius: BorderRadius.circular(radius ?? 8.0),
        ),
        child: Center(child: child),
      ),
    );
  }
}
