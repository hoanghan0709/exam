import 'package:exam/export.dart';
import 'package:flutter/material.dart';

class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.heading,
    required this.title,
    required this.subtitle,
    required this.fieldLabel,
    required this.body,
    required this.bodyBold,
    required this.buttonLabel,
    required this.caption,
    required this.labelSmall,
    required this.link,
    required this.badge,
  });

  final TextStyle heading;

  /// Dùng cho tiêu đề section (18-20px, bold)
  final TextStyle title;
  final TextStyle subtitle;
  final TextStyle fieldLabel;
  final TextStyle body;

  /// Dùng cho body text cần nhấn mạnh (bold)
  final TextStyle bodyBold;
  final TextStyle buttonLabel;
  final TextStyle caption;

  /// Dùng cho label nhỏ (10px) như "Nội dung:", "Tín chỉ:"
  final TextStyle labelSmall;
  final TextStyle link;

  /// Dùng cho badge/chip text (10-11px, bold)
  final TextStyle badge;

  static final light = AppTextStyles(
    heading: GoogleFonts.manrope(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Color(0xFF3D4F3F),
      // letterSpacing: 1.5,
    ),
    title: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1A)),
    subtitle: GoogleFonts.manrope(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Color(0xFF9E9E9E),
      // letterSpacing: 4,
    ),
    fieldLabel: GoogleFonts.manrope(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: Color(0xFF9E9E9E),
      // letterSpacing: 2,
    ),
    body: GoogleFonts.manrope(fontSize: 13, color: Color(0xFF9E9E9E)),
    bodyBold: GoogleFonts.manrope(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Color(0xFF1A1C1A),
    ),
    buttonLabel: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 1),
    caption: GoogleFonts.manrope(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: Color(0xFF9E9E9E),
      // letterSpacing: 3,
    ),
    labelSmall: GoogleFonts.manrope(fontSize: 10, color: Color(0xFF5E5E68)),
    link: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF3D4F3F)),
    badge: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.bold),
  );

  static final dark = AppTextStyles(
    heading: GoogleFonts.manrope(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Color(0xFFF5F5F5),
      // letterSpacing: 1.5,
    ),
    title: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFF5F5F5)),
    subtitle: GoogleFonts.manrope(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Color(0xFF9E9E9E),
      // letterSpacing: 4,
    ),
    fieldLabel: GoogleFonts.manrope(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: Color(0xFF9E9E9E),
      // letterSpacing: 2,
    ),
    body: GoogleFonts.manrope(fontSize: 13, color: Color(0xFF9E9E9E)),
    bodyBold: GoogleFonts.manrope(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Color(0xFFF5F5F5),
    ),
    buttonLabel: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 1),
    caption: GoogleFonts.manrope(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: Color(0xFF9E9E9E),
      // letterSpacing: 3,
    ),
    labelSmall: GoogleFonts.manrope(fontSize: 10, color: Color(0xFF9E9E9E)),
    link: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFD9B382)),
    badge: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.bold),
  );

  @override
  AppTextStyles copyWith({
    TextStyle? heading,
    TextStyle? title,
    TextStyle? subtitle,
    TextStyle? fieldLabel,
    TextStyle? body,
    TextStyle? bodyBold,
    TextStyle? buttonLabel,
    TextStyle? caption,
    TextStyle? labelSmall,
    TextStyle? link,
    TextStyle? badge,
  }) {
    return AppTextStyles(
      heading: heading ?? this.heading,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      fieldLabel: fieldLabel ?? this.fieldLabel,
      body: body ?? this.body,
      bodyBold: bodyBold ?? this.bodyBold,
      buttonLabel: buttonLabel ?? this.buttonLabel,
      caption: caption ?? this.caption,
      labelSmall: labelSmall ?? this.labelSmall,
      link: link ?? this.link,
      badge: badge ?? this.badge,
    );
  }

  @override
  AppTextStyles lerp(AppTextStyles? other, double t) {
    if (other is! AppTextStyles) return this;
    return AppTextStyles(
      heading: TextStyle.lerp(heading, other.heading, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      subtitle: TextStyle.lerp(subtitle, other.subtitle, t)!,
      fieldLabel: TextStyle.lerp(fieldLabel, other.fieldLabel, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      bodyBold: TextStyle.lerp(bodyBold, other.bodyBold, t)!,
      buttonLabel: TextStyle.lerp(buttonLabel, other.buttonLabel, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
      link: TextStyle.lerp(link, other.link, t)!,
      badge: TextStyle.lerp(badge, other.badge, t)!,
    );
  }
}

extension AppTextStylesExtension on BuildContext {
  AppTextStyles get textStyles => Theme.of(this).extension<AppTextStyles>() ?? AppTextStyles.light;
}
