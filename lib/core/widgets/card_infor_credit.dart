import 'package:exam/export.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum TypeExam {
  missing('Học ngay'),
  passed('Đã đạt ✓');

  final String label;
  const TypeExam(this.label);
}

class CardInforCreditWidget extends StatelessWidget {
  final String title;
  final String date;
  final TypeExam score;
  final VoidCallback? onPressed;

  const CardInforCreditWidget({
    super.key,
    required this.title,
    required this.date,
    required this.score,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isPassed = score == TypeExam.passed;
    return PressableWidget(
      onPressed: () {
        onPressed?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.colors.cardBackground.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10.w,
          children: [
            Card(
              elevation: 0,
              color:
                  isPassed
                      ? context.colors.success.withOpacity(0.15)
                      : context.colors.info.withOpacity(0.15),
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                child: Icon(
                  LucideIcons.bookOpenCheck,
                  color: isPassed ? context.colors.success : context.colors.info,
                  size: 20.r,
                ),
              ),
            ),
            Expanded(
              child: Column(
                spacing: 4.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textStyles.bodyBold, maxLines: 4),
                  Text(date, style: context.textStyles.subtitle),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color:
                    isPassed
                        ? context.colors.success.withOpacity(0.15)
                        : context.colors.info.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                score.label,
                style: context.textStyles.badge.copyWith(
                  color: isPassed ? context.colors.success : context.colors.info,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
