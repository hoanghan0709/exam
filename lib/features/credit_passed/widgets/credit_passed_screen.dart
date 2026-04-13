import 'package:exam/common_widgets/common_shimmer.dart';
import 'package:exam/core/widgets/card_infor_credit.dart';
import 'package:exam/core/widgets/empty_data.dart';
import 'package:exam/export.dart';
import 'package:exam/features/home/controller/get_today_schedule_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CreditPassedScreen extends ConsumerWidget {
  const CreditPassedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayScheduleState = ref.watch(getTodayScheduleProvider);
    return CommonScaffold(
      horizontalPadding: 0,
      body: CustomScrollView(
        slivers: [
          CustomPinnedHeaderSliver(
            child: ref
                .watch(mergedTCProvider)
                .when(
                  error: (error, _) => Text('Lỗi tải config: $error'),
                  loading: () => const ShimmerSheetsSection(),
                  data: (listCreditNumber) {
                    final passedCount = listCreditNumber.passedTC.length;
                    final totalCount = todayScheduleState.value?.length ?? 0;
                    final progress = (passedCount / totalCount * 100).clamp(0, 100).ceil();

                    return Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      padding: EdgeInsets.only(top: 10.h),
                      // padding: EdgeInsets.symmetric(vertical: 12.h),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.colors.success.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      // padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            spacing: 16.h,
                            children: [
                              Icon(
                                LucideIcons.circleCheck300,
                                color: context.colors.success,
                                size: 80.w,
                              ),
                              // SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Text(
                                    'Bạn đã hoàn thành $passedCount/$totalCount',
                                    style: context.textStyles.title.copyWith(
                                      color: context.colors.success,
                                    ),
                                  ),
                                  Text(
                                    ' ($progress%)',
                                    style: context.textStyles.title.copyWith(
                                      color: context.colors.info,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
          ),
          ref
              .watch(mergedTCProvider)
              .when(
                error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                data: (listCreditNumber) {
                  if (listCreditNumber.passedTC.isEmpty) {
                    return SliverFillRemaining(
                      child: const EmptyDataWidget(message: 'Bạn chưa hoàn thành tín chỉ nào!'),
                    );
                  }
                  return SliverList.separated(
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemCount: listCreditNumber.passedTC.length,
                    itemBuilder: (context, index) {
                      final tc = listCreditNumber.passedTC[index];
                      return CardInforCreditWidget(
                        onPressed: () => _launchUrl(tc.link ?? '', context),
                        title: tc.topic ?? 'Không xác định',
                        date: 'Tín chỉ: ${tc.content ?? '-'}',
                        score: 'Đã đạt ✓',
                      );
                    },
                  );
                },
              ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url, BuildContext context) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      //show Toast Notifier

      String errorMessage = 'Không thể mở link này, vui lòng thử lại sau.';
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }
}

//custom with PinnedHeaderSliver
class CustomPinnedHeaderSliver extends StatelessWidget {
  final Widget child;

  const CustomPinnedHeaderSliver({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(pinned: true, delegate: _CustomHeaderDelegate(child: child));
  }
}

class _CustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _CustomHeaderDelegate({required this.child});
  static const double _headerHeight = 200.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    //get name scaffold and fill color of container
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: _headerHeight,
      alignment: Alignment.bottomLeft,
      child: child,
    );
  }

  @override
  double get maxExtent => _headerHeight;

  @override
  double get minExtent => _headerHeight;

  @override
  bool shouldRebuild(covariant _CustomHeaderDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
