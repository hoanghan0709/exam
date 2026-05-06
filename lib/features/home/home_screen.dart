//import export
import 'package:exam/common_widgets/common_shimmer.dart';
import 'package:exam/core/widgets/card_infor_credit.dart';
import 'package:exam/core/widgets/empty_data.dart';
import 'package:exam/export.dart';
import 'package:exam/features/home/controller/get_sheets_timeline_provider.dart';
import 'package:exam/features/home/controller/get_today_schedule_provider.dart';
import 'package:exam/features/home/widgets/alert_congratulatory.dart';
import 'package:exam/features/home/widgets/slivder_gap.dart';
import 'package:exam/utils/ext_formatter.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  // Thêm state để toggle hiển thị
  bool _showAll = false;
  late int _maxItems;

  @override
  void initState() {
    super.initState(); //code moi tren dev
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(getConfigSheetsProvider);
    final mergedTimeline = ref.watch(mergedTimelineProvider);
    final userAsync = ref.watch(userModelProvider);
    final staffInfoAsync = ref.watch(getStaffInfoProvider);
    ref.watch(getTodayScheduleProvider);
    ref.watch(getSheetsTimelineProvider);
    final sheetsState = ref.watch(getSheetsProvider);

    return userAsync.when(
      loading: () => const Center(child: ShimmerSheetsSection()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data:
          (user) => RefreshIndicator(
            onRefresh: () async {
              // Refresh lại các provider cần thiết khi kéo xuống để cập nhật dữ liệu mới nhất
              await onRefresh();
            },
            child: CustomScrollView(
              slivers: [
                PinnedHeaderSliver(
                  child: _buildHeroSection(userAsync.value, staffInfoAsync, context, sheetsState),
                ),
                if (staffInfoAsync.value?.staffInfo.roadmap == EnumRoadmap.newStaff)
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: 12.h),
                        mergedTimeline.when(
                          loading:
                              () => const Center(
                                child: ShimmerBox(height: 60, width: double.infinity),
                              ),
                          error: (error, stack) => Center(child: Text('Error: $error')),
                          data: (timeline) {
                            final getInforStaff =
                                ref.watch(mergedTCProvider).value?.isPassed ?? false;
                            if (getInforStaff) {
                              return SizedBox();
                            }
                            return Stack(
                              children: [
                                Column(
                                  spacing: 4.h,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        style: GoogleFonts.manrope(),
                                        children: [
                                          TextSpan(
                                            text: 'Lộ trình dành cho vị trí',
                                            style: context.textStyles.heading.copyWith(
                                              color: context.colors.textPrimary,
                                              fontSize: 16,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' NHÂN VIÊN MỚI',
                                            style: context.textStyles.heading.copyWith(
                                              color: context.colors.error,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Card(
                                      color: context.colors.cardBackground.withOpacity(0.6),
                                      elevation: 1,
                                      child: Padding(
                                        padding: EdgeInsets.all(12.r),
                                        child: Text.rich(
                                          TextSpan(
                                            style: GoogleFonts.manrope(),
                                            children: [
                                              const TextSpan(text: 'Bạn phải đạt '),
                                              TextSpan(
                                                text: '${timeline.totalCredit}',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              TextSpan(text: ' tín chỉ đến ngày '),
                                              TextSpan(
                                                text: '${timeline.timeline} ',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: 'để hoàn thành lộ trình dành cho vị trí',
                                              ),
                                              TextSpan(
                                                text:
                                                    ' ${staffInfoAsync.value?.staffInfo.position?.value.toUpperCase() ?? ''}',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 0,
                                  top: 30,
                                  child: Badge(
                                    label: Text('Mới'),
                                    backgroundColor: context.colors.error,
                                    textStyle: context.textStyles.badge.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                SliverGap(12.h),
                // Sliver 3: Header "Tín chỉ còn thiếu"
                SliverToBoxAdapter(
                  child: ref
                      .watch(mergedTCProvider)
                      .when(
                        error: (error, _) => Text('Lỗi tải config: $error'),
                        loading: () => const ShimmerSheetsSection(),
                        data: (listCreditNumber) {
                          if (listCreditNumber.isPassed) {
                            return SizedBox();
                          }
                          if (listCreditNumber.isWrongPosition) {
                            return Text(
                              "Đã phát hiện tín chỉ không tồn tại trong vị trí hiện tại, vui lòng liên hệ quản lý để được hỗ trợ.",
                              textAlign: TextAlign.center,
                            );
                          }
                          final todaySchedule = ref.watch(getTodayScheduleProvider);
                          int missing = listCreditNumber.missingTC.length;
                          int total = todaySchedule.value?.length ?? 0;

                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Row(
                                  spacing: 6.w,
                                  children: [
                                    Text(
                                      "Tín chỉ còn thiếu ($missing/$total)",
                                      style: context.textStyles.title,
                                    ),
                                    Text(
                                      "(Chọn để học ngay)",
                                      style: context.textStyles.body.copyWith(
                                        color: context.colors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                ),

                // Sliver 4: List tín chỉ — LAZY RENDER ✅
                ref
                    .watch(mergedTCProvider)
                    .when(
                      error: (error, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                      loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                      data: (listCreditNumber) {
                        if (listCreditNumber.missingTC.isEmpty) {
                          _maxItems = 0;
                        } else {
                          _maxItems = listCreditNumber.missingTC.length.clamp(0, 5);
                        }
                        if (listCreditNumber.isPassed) {
                          final staffInfoAsync = ref.watch(getStaffInfoProvider);
                          if (staffInfoAsync.value?.staffInfo.roadmap?.mappedValue != null) {
                            return AlertCongratulatory();
                          }
                        }
                        if (listCreditNumber.isWrongPosition) {
                          return const SliverToBoxAdapter(child: SizedBox.shrink());
                        }
                        return listCreditNumber.missingTC.isEmpty
                            ? SliverToBoxAdapter(
                              child: EmptyDataWidget(message: 'Bạn đã hoàn thành tất cả tín chỉ!'),
                            )
                            : SliverList.separated(
                              separatorBuilder: (_, __) => const SizedBox(height: 10),
                              itemCount:
                                  _showAll
                                      ? listCreditNumber.missingTC.length
                                      : listCreditNumber.missingTC.length.clamp(0, _maxItems),
                              itemBuilder: (context, index) {
                                final tc = listCreditNumber.missingTC[index];
                                return CardInforCreditWidget(
                                  onPressed: () => _launchUrl(tc.link ?? ''),
                                  title: tc.topic ?? 'Không xác định',
                                  date: 'Tín chỉ: ${tc.content ?? '-'}',
                                  score: TypeExam.missing,
                                );
                              },
                            );
                      },
                    ),

                // Sliver 5: Nút "Xem thêm" (chỉ hiện khi còn items ẩn)
                ref
                    .watch(mergedTCProvider)
                    .when(
                      error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                      loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                      data:
                          (listCreditNumber) =>
                              listCreditNumber.missingTC.length > _maxItems
                                  ? SliverToBoxAdapter(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12.h),
                                      child: Center(
                                        child: TextButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              _showAll = !_showAll;
                                            });
                                          },
                                          icon: Icon(
                                            _showAll ? Icons.expand_less : Icons.expand_more,
                                            color: context.colors.primary,
                                          ),
                                          label: Text(
                                            _showAll
                                                ? 'Thu gọn'
                                                : 'Xem thêm (${listCreditNumber.missingTC.length - _maxItems} còn lại)',
                                            style: context.textStyles.bodyBold.copyWith(
                                              color: context.colors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  : const SliverToBoxAdapter(child: SizedBox.shrink()),
                    ),

                // Spacing cuối
                SliverToBoxAdapter(child: SizedBox(height: 150)),
              ],
            ),
          ),
      //  SingleChildScrollView(
      //   child: Column(
      //     spacing: 24.h,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //     ],
      //   ),
      // ),
    );
  }

  Future<void> onRefresh() async {
    await Future.wait([
      ref.refresh(getSheetsProvider.future),
      ref.refresh(getConfigSheetsProvider.future),
      ref.refresh(getStaffInfoProvider.future),
      ref.refresh(mergedTCProvider.future),
      ref.refresh(getTodayScheduleProvider.future),
    ]);
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      //show Toast Notifier
      if (mounted) {
        String errorMessage = 'Không thể mở link này, vui lòng thử lại sau.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }

  // ...existing code...
  Widget _buildHeroSection(
    UserModel? user,
    AsyncValue<GetStaffInfoState> staffInfoAsync,
    BuildContext context,
    AsyncValue<GetSheetState> sheetsState,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.colors.cardBackground.withOpacity(0.6),
            image: DecorationImage(image: Assets.images.bgBlue.provider(), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 24,
          right: 24,
          child: Column(
            spacing: 8.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: staffInfoAsync.when(
                      loading:
                          () => Column(
                            children: List.generate(
                              4,
                              (index) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: const ShimmerBox(height: 16, width: double.infinity),
                              ),
                            ),
                          ),
                      error: (error, stack) => Text('Lỗi tải thông tin: $error'),
                      data:
                          (staffInfo) => RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: GoogleFonts.manrope(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: context.colors.textPrimary,
                              ),
                              children: [
                                TextSpan(text: 'Chào bạn, '),
                                TextSpan(
                                  text:
                                      staffInfoAsync.value!.staffInfo.name?.extractString ??
                                      "Không xác định",
                                  style: TextStyle(color: context.colors.primary),
                                ),
                              ],
                            ),
                          ),
                    ),
                  ),
                  // const Icon(Icons.waving_hand_rounded, color: Color(0xFF545C8C)),
                ],
              ),
              staffInfoAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => Text('Lỗi tải thông tin: $error'),
                data: (staffInfo) {
                  String? nameBranch = sheetsState.value?.branchName;
                  //log nameBranch
                  AppLogger.debug('Branch name: $nameBranch');
                  return Column(
                    spacing: 2.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      inforRowCard(staffInfo.staffInfo.position?.value, context, 'Vị trí •'),
                      inforRowCard(staffInfo.staffInfo.startDate, context, 'Ngày vào làm •'),
                      inforRowCard(staffInfo.staffInfo.totalDays, context, 'Số ngày đã làm•'),
                      inforRowCard(staffInfo.staffInfo.roadmap?.mappedValue, context, 'Lộ trình •'),
                      inforRowCard(nameBranch ?? "Không xác định", context, 'Chi nhánh •'),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        Positioned(
          top: 12.h,
          left: 16.w,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 12.w,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(user?.avatar ?? AppConst.defaultAvatar),
              ),
              Text(
                'Thông tin nhân viên',
                style: GoogleFonts.manrope(
                  color: context.colors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row inforRowCard(String? staffInfo, BuildContext context, String title) {
    return Row(
      children: [
        Text(title),
        Text(
          ' ${staffInfo?.toUpperCase() ?? 'Không xác định'}',
          style: context.textStyles.body.copyWith(
            fontWeight: FontWeight.w900,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
