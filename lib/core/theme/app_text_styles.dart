import 'package:flutter/material.dart';

class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.heading,
    required this.subtitle,
    required this.fieldLabel,
    required this.body,
    required this.buttonLabel,
    required this.caption,
    required this.link,
  });

  final TextStyle heading;
  final TextStyle subtitle;
  final TextStyle fieldLabel;
  final TextStyle body;
  final TextStyle buttonLabel;
  final TextStyle caption;
  final TextStyle link;

  static const light = AppTextStyles(
    heading: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Color(0xFF3D4F3F),
      letterSpacing: 1.5,
    ),
    subtitle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Color(0xFF9E9E9E),
      letterSpacing: 4,
    ),
    fieldLabel: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: Color(0xFF9E9E9E),
      letterSpacing: 2,
    ),
    body: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
    buttonLabel: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 1),
    caption: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: Color(0xFF9E9E9E),
      letterSpacing: 3,
    ),
    link: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF3D4F3F)),
  );

  static const dark = AppTextStyles(
    heading: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Color(0xFFF5F5F5),
      letterSpacing: 1.5,
    ),
    subtitle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Color(0xFF9E9E9E),
      letterSpacing: 4,
    ),
    fieldLabel: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: Color(0xFF9E9E9E),
      letterSpacing: 2,
    ),
    body: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
    buttonLabel: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 1),
    caption: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: Color(0xFF9E9E9E),
      letterSpacing: 3,
    ),
    link: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFD9B382)),
  );

  @override
  AppTextStyles copyWith({
    TextStyle? heading,
    TextStyle? subtitle,
    TextStyle? fieldLabel,
    TextStyle? body,
    TextStyle? buttonLabel,
    TextStyle? caption,
    TextStyle? link,
  }) {
    return AppTextStyles(
      heading: heading ?? this.heading,
      subtitle: subtitle ?? this.subtitle,
      fieldLabel: fieldLabel ?? this.fieldLabel,
      body: body ?? this.body,
      buttonLabel: buttonLabel ?? this.buttonLabel,
      caption: caption ?? this.caption,
      link: link ?? this.link,
    );
  }

  @override
  AppTextStyles lerp(AppTextStyles? other, double t) {
    if (other is! AppTextStyles) return this;
    return AppTextStyles(
      heading: TextStyle.lerp(heading, other.heading, t)!,
      subtitle: TextStyle.lerp(subtitle, other.subtitle, t)!,
      fieldLabel: TextStyle.lerp(fieldLabel, other.fieldLabel, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      buttonLabel: TextStyle.lerp(buttonLabel, other.buttonLabel, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      link: TextStyle.lerp(link, other.link, t)!,
    );
  }
}

extension AppTextStylesExtension on BuildContext {
  AppTextStyles get textStyles => Theme.of(this).extension<AppTextStyles>() ?? AppTextStyles.light;
}
