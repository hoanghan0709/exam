//import export
import 'package:exam/export.dart';
import 'package:exam/features/home/widgets/slivder_gap.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  // Thêm state để toggle hiển thị
  bool _showAll = false;
  late int _maxItems;

  // Định nghĩa màu gradient đặc trưng từ HTML
  static const LinearGradient signatureGradient = LinearGradient(
    colors: [Color(0xFF545C8C), Color(0xFF48507F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState(); //code moi tren dev
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userModelProvider);
    final sheetsAsync = ref.watch(getSheetsProvider);
    final staffInfoAsync = ref.watch(getStaffInfoProvider);

    final ids = ["sdfjkdlsaaf", "fjdkslajfl"]; //all branch
    // final links = ids .map(idTolinks); // giả sử idTolinks là hàm chuyển đổi id thành link
    // // Eg: idTolinks(String id) => "https://example.com/sheet/$id";
    // final datas = links.map(linkToData); // giả sử linkToData là hàm lấy dữ liệu từ link
    // Eg: linkToData(String link) => fetchDataFromLink(link);

    return userAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data:
          (user) => CustomScrollView(
            slivers: [
              // Sliver 1: Hero Section (render 1 lần, không lazy)
              SliverToBoxAdapter(
                child: _buildHeroSection(userAsync.value, staffInfoAsync, context),
              ),
              SliverGap(12.h),
              // Sliver 2: Sheets Section
              SliverToBoxAdapter(
                child: sheetsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Lỗi tải sheets: $error')),
                  data: (sheets) => _buildSheetsSection(sheets.spreadsheet),
                ),
              ),
              SliverGap(12.h),
              // Sliver 3: Header "Tín chỉ còn thiếu"
              SliverToBoxAdapter(
                child: ref
                    .watch(mergedTCProvider)
                    .when(
                      error: (error, _) => Text('Lỗi tải config: $error'),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      data:
                          (listCreditNumber) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Row(
                              spacing: 6.w,
                              children: [
                                Text(
                                  "Tín chỉ còn thiếu (${listCreditNumber.length})",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text("(Chọn để học ngay)", style: context.textStyles.body),
                              ],
                            ),
                          ),
                    ),
              ),

              // Sliver 4: List tín chỉ — LAZY RENDER ✅
              ref
                  .watch(mergedTCProvider)
                  .when(
                    error: (error, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                    loading:
                        () => const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    data: (listCreditNumber) {
                      if (listCreditNumber.isEmpty) {
                        _maxItems = 0;
                      } else {
                        _maxItems = listCreditNumber.length.clamp(0, 5);
                      }
                      return listCreditNumber.isEmpty
                          ? SliverToBoxAdapter(
                            child: Container(
                              height: 140,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 8,
                                children: [
                                  Icon(Icons.blinds_closed_sharp, color: Colors.red),
                                  Text('Danh sách tín chỉ trống!'),
                                ],
                              ),
                            ),
                          )
                          : SliverList.separated(
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemCount:
                                _showAll
                                    ? listCreditNumber.length
                                    : listCreditNumber.length.clamp(0, _maxItems),
                            itemBuilder: (context, index) {
                              final tc = listCreditNumber[index];
                              return GestureDetector(
                                onTap: () => _launchUrl(tc.link ?? ''),
                                child: _buildResultItem(
                                  tc.topic ?? 'Không xác định',
                                  'Tín chỉ: ${tc.content ?? '-'}',
                                  'Học ngay',
                                ),
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
                            listCreditNumber.length > _maxItems
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
                                              : 'Xem thêm (${listCreditNumber.length - _maxItems} còn lại)',
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
                    child: RichText(
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
                            text: '${user?.name}!',
                            style: TextStyle(color: Color(0xFF545C8C)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // const Icon(Icons.waving_hand_rounded, color: Color(0xFF545C8C)),
                ],
              ),
              staffInfoAsync.when(
                loading: () => const Text('Đang tải thông tin...'),
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
        // Positioned(
        //   top: 12.h,
        //   right: 10.w,
        //   child: IconButton(
        //     style: IconButton.styleFrom(
        //       backgroundColor: Colors.grey.withOpacity(0.5),
        //       // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        //       // padding: const EdgeInsets.all(4),
        //       // shadowColor: Colors.black.withOpacity(0.1),
        //       elevation: 1,
        //     ),
        //     onPressed: () {},
        //     icon: const Icon(Icons.power_settings_new, color: Colors.red),
        //   ),
        // ),
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

  Widget _buildLearningGoalCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF31323B).withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFBFC6FD),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Text(
                  'HỌC TẬP MỤC TIÊU',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
              ),
              const Icon(Icons.auto_awesome, color: Color(0xFF545C8C)),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Chương trình Đào tạo Kỹ thuật Bậc cao',
            style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tiếp tục hoàn thành các học phần về hạ tầng mạng và bảo mật để đạt chứng chỉ chuyên gia của năm.',
            style: TextStyle(color: Color(0xFF5E5E68)),
          ),
          const SizedBox(height: 32),
          Row(
            spacing: 10.w,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 8.w,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Flexible(
                          child: Text(
                            'Tiến độ hoàn thành',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '85%',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF545C8C),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: Container(
                        height: 12,
                        width: double.infinity,
                        color: const Color(0xFFE3E1ED),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.85,
                          child: Container(
                            decoration: const BoxDecoration(gradient: signatureGradient),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: const Color(0xFF545C8C).withOpacity(0.4),
                  elevation: 8,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: signatureGradient,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 08),
                    child: const Text(
                      'Học ngay',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreditsCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F2FB),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.military_tech, size: 40, color: Color(0xFF545C8C)),
          ),
          const SizedBox(height: 16),
          const Text(
            'TÍN CHỈ CÒN THIẾU',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF5E5E68)),
          ),
          Text('02', style: GoogleFonts.manrope(fontSize: 60, fontWeight: FontWeight.bold)),
          const Text(
            'Bạn chỉ cần hoàn thành 2 tín chỉ nữa để đạt KPI học tập quý này.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF5E5E68)),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lịch học hôm nay',
                style: GoogleFonts.manrope(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Text(
                'Xem tất cả',
                style: TextStyle(
                  color: Color(0xFF545C8C),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildScheduleItem(
            'Thứ 3',
            '14',
            'Bảo trì Hệ thống Core',
            '09:00 - 11:30 • Zoom Online',
            const Color(0xFFE0E1F9),
          ),
          const SizedBox(height: 16),
          _buildScheduleItem(
            'Thứ 3',
            '14',
            'Kỹ năng làm việc nhóm',
            '14:00 - 15:30 • Phòng họp 4',
            const Color(0xFFF1CEFC),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String day, String date, String title, String info, Color bgColor) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(day, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
              Text(date, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(info, style: const TextStyle(color: Color(0xFF5E5E68), fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSheetsSection(SpreadsheetEntity sheets) {
    if (sheets.sheets == null || sheets.sheets!.isEmpty) {
      return const Center(child: Text('Không có dữ liệu'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lịch học hôm nay',
          style: GoogleFonts.manrope(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sheets.sheets!.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final sheet = sheets.sheets![index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(sheet.properties?.title ?? "", style: const TextStyle(fontSize: 14)),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentResultsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E7F1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: _buildResultItem('An toàn thông tin', '12/10/2023', '9.5/10'),
    );
  }

  Widget _buildResultItem(String title, String date, String score) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 4.w,
            children: [
              Text('Nội dung:', style: const TextStyle(fontSize: 10, color: Color(0xFF5E5E68))),
              Expanded(
                child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(fontSize: 10, color: Color(0xFF5E5E68))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  score,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.dashboard, 'Dashboard', true),
          _buildNavItem(Icons.event_note, 'Schedule', false),
          _buildNavItem(Icons.account_circle, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration:
          isActive
              ? BoxDecoration(
                color: const Color(0xFF545C8C),
                borderRadius: BorderRadius.circular(99),
              )
              : null,
      child: Row(
        children: [
          Icon(icon, color: isActive ? Colors.white : const Color(0xFF545C8C).withOpacity(0.6)),
          if (isActive) ...[
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
