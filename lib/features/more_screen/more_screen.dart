import 'package:exam/common_widgets/common_button.dart';
import 'package:exam/export.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    //show snackbar when userModel changes from having data to id == null (logged out)
    ref.listen<AsyncValue<UserModel>>(userModelProvider, (prev, next) {
      final wasLoggedIn = prev?.value?.id != null;
      final isLoggedOut = next.value?.id == null;

      if (wasLoggedIn && isLoggedOut && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade300,
            behavior: SnackBarBehavior.floating,
            content: Text('Đã đăng xuất'),
          ),
        );
      }
    });

    final userAsync = ref.watch(userModelProvider);
    final staffInfoAsync = ref.read(getStaffInfoProvider);

    return userAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data:
          (user) => Column(
            spacing: 16.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20.w,
                children: [
                  //avatar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: CommonBlurHash(
                      hash: 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
                      imageUrl: user.avatar,
                      width: 140,
                      height: 180,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            width: 140,
                            height: 180,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.person, size: 80, color: Colors.white),
                          ),
                    ),
                  ),
                  //infor
                  Expanded(
                    child: Column(
                      spacing: 8.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name ?? 'Unknown',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vị trí',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            staffInfoAsync.when(
                              loading: () => const SizedBox.shrink(),
                              error: (e, _) => const SizedBox.shrink(),
                              data: (staffInfoState) {
                                final staffInfo = staffInfoState.staffInfo;
                                return Text(staffInfo.position?.value ?? 'Không có vị trí');
                              },
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                            Text(user.email ?? 'Không có email'),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lộ trình',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            staffInfoAsync.when(
                              loading: () => const SizedBox.shrink(),
                              error: (e, _) => const SizedBox.shrink(),
                              data: (staffInfoState) {
                                final staffInfo = staffInfoState.staffInfo;
                                return Text(
                                  staffInfo.roadmap?.mappedValue.toUpperCase() ?? 'Không có vị trí',
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              ref
                  .watch(mergedTCProvider)
                  .when(
                    error: (error, stackTrace) => Text('Lỗi tải config: $error'),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    data: (listCreditNumber) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (listCreditNumber.missingTC.isNotEmpty)
                            Text(
                              'Tín chỉ còn thiếu (${listCreditNumber.missingTC.length})',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          Wrap(
                            spacing: 8.h,
                            children: [
                              for (var item in listCreditNumber.missingTC)
                                Container(
                                  width: 70,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    item.content.toString(),
                                    style: const TextStyle(color: Colors.blueAccent, fontSize: 14),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
              SizedBox(height: 40.h),
              Row(children: [Expanded(child: _buildButtonLogOut())]),
            ],
          ),
    );
  }

  Widget _buildButtonLogOut() {
    return CommonButton(
      height: 60,
      radius: 22,
      onPressed: () async {
        await ref.read(googleSignInProvider.notifier).signOut();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Icon(LucideIcons.logOut, color: Colors.white),
          Text('Đăng xuất', style: context.textStyles.buttonLabel.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}
