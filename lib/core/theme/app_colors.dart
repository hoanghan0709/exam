import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.accent,
    required this.background,
    required this.cardBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.border,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
  });

  final Color primary;
  final Color accent;
  final Color background;
  final Color cardBackground;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color border;
  final Color error;
  final Color success;
  final Color warning;
  final Color info;

  static const light = AppColors(
    primary: Color(0xFF545C8C),
    // primary: Color(0xFF3D4F3F),
    accent: Color(0xFFD9B382),
    background: Color(0xFFFCFAF7),
    cardBackground: Colors.white,
    textPrimary: Color(0xFF1A1C1A),
    textSecondary: Color(0xFF9E9E9E),
    textHint: Color(0xFFBDBDBD),
    border: Color(0xFFEEEEEE),
    error: Color(0xFFE53935),
    success: Color(0xFF43A047),
    warning: Color(0xFFF57C00),
    info: Color(0xFF1976D2),
  );

  static const dark = AppColors(
    primary: Color(0xFF545C8C),
    accent: Color(0xFFD9B382),
    background: Color(0xFF1A1C1A),
    cardBackground: Color(0xFF212121),
    textPrimary: Color(0xFFF5F5F5),
    textSecondary: Color(0xFF9E9E9E),
    textHint: Color(0xFF616161),
    border: Color(0xFF424242),
    error: Color(0xFFEF5350),
    success: Color(0xFF66BB6A),
    warning: Color(0xFFFFB74D),
    info: Color(0xFF42A5F5),
  );

  @override
  AppColors copyWith({
    Color? primary,
    Color? accent,
    Color? background,
    Color? cardBackground,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? border,
    Color? error,
    Color? success,
    Color? warning,
    Color? info,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      background: background ?? this.background,
      cardBackground: cardBackground ?? this.cardBackground,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      border: border ?? this.border,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      background: Color.lerp(background, other.background, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      border: Color.lerp(border, other.border, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

extension AppColorsExtension on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>() ?? AppColors.light;
}

//class primary
class PrimaryColor {}
