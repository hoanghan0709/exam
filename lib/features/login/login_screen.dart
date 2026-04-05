//create with CommonWidget of riverpod

import 'package:exam/common_widgets/common_pressable.dart';
import 'package:exam/common_widgets/common_scaffold.dart';
import 'package:exam/export.dart';
import 'package:exam/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/widgets.dart';

import '../../common_widgets/common_textfield.dart';
import '../../config/router/app_paths.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    final googleSignInAsync = ref.watch(googleSignInProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => ref.read(googleSignInProvider.notifier).signIn(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 42.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.r),
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.r,
                      offset: Offset(0, 4.r),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20.h,
                  children: [
                    Column(
                      spacing: 6.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Assets.images.exam.image(
                          alignment: Alignment.centerLeft,
                          width: 100.w,
                          height: 60.h,
                        ),
                        Text(
                          'Chào mừng',
                          style: context.textStyles.heading.copyWith(fontSize: 22.sp),
                        ),
                        Text('Đăng nhập tài khoản Gmail của bạn', style: context.textStyles.body),
                      ],
                    ),
                    googleSignInAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error:
                          (e, _) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Error: $e'),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => ref.invalidate(googleSignInProvider),
                                  child: const Text('RETRY'),
                                ),
                              ],
                            ),
                          ),
                      data:
                          (user) => Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (user != null) ...[
                                ListTile(
                                  leading: GoogleUserCircleAvatar(identity: user),
                                  title: Text(user.displayName ?? ''),
                                  subtitle: Text(user.email),
                                ),
                                const Text('Signed in successfully.'),
                                ElevatedButton(
                                  onPressed:
                                      () => ref.read(googleSignInProvider.notifier).signOut(),
                                  child: const Text('SIGN OUT'),
                                ),
                              ] else ...[
                                // const Text(
                                //   'You are not currently signed in.',
                                // ), //translate to vietnamese: 'Bạn chưa đăng nhập.',
                                if (GoogleSignIn.instance.supportsAuthenticate())
                                  //create button circle with google icon
                                  Container(
                                    width: 60.r,
                                    height: 60.r,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4.r,
                                          offset: Offset(0, 2.r),
                                        ),
                                      ],
                                    ),
                                    child: FaIcon(
                                      FontAwesomeIcons.google,
                                      size: 20.r,
                                      color: Colors.red,
                                    ),
                                  ),
                              ],
                            ],
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
