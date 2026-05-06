import 'package:exam/export.dart';

class AlertCongratulatory extends ConsumerWidget {
  const AlertCongratulatory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffInfoAsync = ref.watch(getStaffInfoProvider);
    return SliverToBoxAdapter(
      child: Column(
        spacing: 12.h,
        children: [
          Text(
            "Xin chúc mừng, Bạn đã hoàn thành lộ trình dành cho ${staffInfoAsync.value?.staffInfo.roadmap?.mappedValue}!",
            style: context.textStyles.bodyBold.copyWith(
              color: context.colors.primary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          //add shape circle with svg party inside with out Container
          ClipOval(
            child: SizedBox.fromSize(
              size: Size.fromRadius(80),
              child: Assets.images.icPassed.image(fit: BoxFit.fill),
            ),
          ),
        ],
      ),
    );
  }
}
