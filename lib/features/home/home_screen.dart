//import export
import 'package:exam/common_widgets/common_shimmer.dart';
import 'package:exam/core/widgets/card_infor_credit.dart';
import 'package:exam/core/widgets/empty_data.dart';
import 'package:exam/export.dart';
import 'package:exam/features/home/controller/get_sheets_timeline_provider.dart';
import 'package:exam/features/home/controller/get_today_schedule_provider.dart';
import 'package:exam/features/home/widgets/slivder_gap.dart';
import 'package:exam/utils/ext_formatter.dart';
import 'package:intl/intl.dart';

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
    ref.watch(getSheetsProvider);
    ref.watch(getConfigSheetsProvider);
    final mergedTimeline = ref.watch(mergedTimelineProvider);
    final userAsync = ref.watch(userModelProvider);
    final staffInfoAsync = ref.watch(getStaffInfoProvider);
    ref.watch(getTodayScheduleProvider);
    ref.watch(getSheetsTimelineProvider);

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
                  child: _buildHeroSection(userAsync.value, staffInfoAsync, context),
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
                          data:
                              (timeline) => Column(
                                spacing: 4.h,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      style: GoogleFonts.manrope(),
                                      children: [
                                        TextSpan(
                                          text: 'Lộ trình dành cho',
                                          style: context.textStyles.fieldLabel.copyWith(
                                            color: Colors.grey,
                                            wordSpacing: 1,
                                            fontSize: 16,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' NHÂN VIÊN MỚI',
                                          style: context.textStyles.fieldLabel.copyWith(
                                            color: Colors.black,
                                            wordSpacing: 1,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      style: GoogleFonts.manrope(),
                                      children: [
                                        const TextSpan(text: 'Bạn phải đạt '),
                                        TextSpan(
                                          text: '${timeline.totalCredit}',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: ' tín chỉ đến ngày '),
                                        TextSpan(
                                          text: '${timeline.timeline} ',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: 'để hoàn thành lộ trình dành cho'),
                                        TextSpan(
                                          text:
                                              ' ${staffInfoAsync.value?.staffInfo.roadmap?.value.toUpperCase() ?? ''}',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text("(Chọn để học ngay)", style: context.textStyles.body),
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
                        if (listCreditNumber.isWrongPosition) {
                          return SliverToBoxAdapter(child: SizedBox.shrink());
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
                                  score: 'Học ngay',
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
                                            color: const Color(0xFF545C8C),
                                          ),
                                          label: Text(
                                            _showAll
                                                ? 'Thu gọn'
                                                : 'Xem thêm (${listCreditNumber.missingTC.length - _maxItems} còn lại)',
                                            style: const TextStyle(
                                              color: Color(0xFF545C8C),
                                              fontWeight: FontWeight.bold,
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
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 190,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: CommonBlurHash(
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
              fit: BoxFit.cover,
              hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
              imageUrl: AppConst.imgDashBoard,
            ),
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
                                color: const Color(0xFF31323B),
                              ),
                              children: [
                                TextSpan(text: 'Chào bạn, '),
                                TextSpan(
                                  text: '${staffInfoAsync.value!.staffInfo.name?.extractString}!',
                                  style: TextStyle(color: Color(0xFF545C8C)),
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      inforRowCard(staffInfo.staffInfo.position?.value, context, 'Vị trí •'),
                      inforRowCard(staffInfo.staffInfo.startDate, context, 'Ngày vào làm •'),
                      inforRowCard(staffInfo.staffInfo.totalDays, context, 'Số ngày đã làm•'),
                      inforRowCard(staffInfo.staffInfo.roadmap?.value, context, 'Lộ trình •'),
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
                  color: const Color(0xFF545C8C),
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
          ' ${staffInfo ?? 'Không xác định'}',
          style: context.textStyles.body.copyWith(fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ],
    );
  }
}
