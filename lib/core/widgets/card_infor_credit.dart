import 'package:exam/export.dart';

class CardInforCreditWidget extends StatelessWidget {
  final String title;
  final String date;
  final String score;
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
    final isPassed = score.contains('Đã đạt');
    return PressableWidget(
      onPressed: () {
        onPressed?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: context.colors.cardBackground.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 4.w,
              children: [
                Text('Nội dung:', style: context.textStyles.labelSmall),
                Expanded(child: Text(title, style: context.textStyles.bodyBold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date, style: context.textStyles.labelSmall),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color:
                        isPassed
                            ? context.colors.success.withOpacity(0.15)
                            : context.colors.info.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    score,
                    style: context.textStyles.badge.copyWith(
                      color: isPassed ? context.colors.success : context.colors.info,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
