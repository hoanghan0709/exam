import 'package:exam/common_widgets/common_shimmer.dart';
import 'package:exam/core/widgets/card_infor_credit.dart';
import 'package:exam/core/widgets/empty_data.dart';
import 'package:exam/export.dart';
import 'package:exam/features/home/controller/get_today_schedule_provider.dart';
import 'package:exam/features/home/widgets/alert_congratulatory.dart';
import 'package:exam/features/home/widgets/slivder_gap.dart';

class CreditPassedScreen extends ConsumerWidget {
  const CreditPassedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //watch today schedule to get total credit number of possible credit to pass
    final todayScheduleState = ref.watch(getTodayScheduleProvider);
    //get passed credit number and total credit number to calculate progress
    late final int passedCount;
    late final int totalCount;
    late final int progress;

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
                    if (listCreditNumber.isPassed) {
                      passedCount = todayScheduleState.value?.length ?? -1;
                      totalCount = todayScheduleState.value?.length ?? -1;
                      progress = 100;
                    } else {
                      passedCount = listCreditNumber.passedTC.length;
                      totalCount = todayScheduleState.value?.length ?? -1;
                      progress = (passedCount / totalCount * 100).clamp(0, 100).ceil();
                    }
                    return Center(
                      child: Column(
                        spacing: 14.h,
                        children: [
                          SizedBox(height: 10.h),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipOval(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(58.r),
                                  child: Assets.images.iconCup.image(width: 96.w, height: 96.h),
                                ),
                              ),
                              // child: Assets.images.iconCup.image(width: 96.w, height: 96.h),
                              // ),
                              SizedBox(
                                height: 140,
                                width: 140,
                                child: CircularProgressIndicator(
                                  value: passedCount / totalCount,
                                  strokeWidth: 8,
                                  valueColor: AlwaysStoppedAnimation(
                                    context.colors.success.withOpacity(0.8),
                                  ),
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Bạn đã hoàn thành ',
                                          style: context.textStyles.title.copyWith(),
                                        ),
                                        TextSpan(
                                          text: '$passedCount/$totalCount',
                                          style: context.textStyles.title.copyWith(
                                            color: context.colors.success,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' tín chỉ',
                                          style: context.textStyles.title.copyWith(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'và đạt được',
                                          style: context.textStyles.title.copyWith(),
                                        ),
                                        TextSpan(
                                          text: ' $progress%',
                                          style: context.textStyles.title.copyWith(
                                            color: context.colors.success,
                                          ),
                                        ),
                                      ],
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
                  //check if passed all credit, show alert congratulatory
                  if (listCreditNumber.isPassed) {
                    final staffInfoAsync = ref.watch(getStaffInfoProvider);
                    if (staffInfoAsync.value?.staffInfo.roadmap?.mappedValue != null) {
                      return AlertCongratulatory();
                    }
                  }
                  if (listCreditNumber.passedTC.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 80.h),
                        child: const EmptyDataWidget(message: 'Bạn chưa hoàn thành tín chỉ nào!'),
                      ),
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
                        score: TypeExam.passed,
                      );
                    },
                  );
                },
              ),
          SliverGap(MediaQuery.viewInsetsOf(context).bottom + 120.h),
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
  static const double _headerHeight = 260.0;

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
