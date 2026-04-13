import 'package:exam/features/credit_passed/widgets/credit_passed_screen.dart';
import 'package:exam/features/login/entity/google_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/home_screen.dart';
import '../../features/login/login_screen.dart';
import '../../features/main/main_screen.dart';
import '../../features/more_screen/more_screen.dart';
import 'app_paths.dart';

/// A simple ChangeNotifier that can be triggered to refresh GoRouter.
class GoRouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = GoRouterRefreshNotifier();

  // Lắng nghe thay đổi của userModelProvider → trigger GoRouter redirect
  ref.listen(userModelProvider, (_, __) {
    refreshNotifier.notify();
  });
  final router = GoRouter(
    initialLocation: AppPaths.login.path,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final userAsync = ref.read(userModelProvider);
      // Đang loading từ storage, chưa biết user → không redirect
      if (userAsync.isLoading) return null;

      final bool isLoggedIn = userAsync.value?.id != null;

      final currentPath = state.matchedLocation;

      final loginPaths = {AppPaths.login.path, AppPaths.loginEmail.path, AppPaths.login2.path};

      if (isLoggedIn) {
        // Đã login → nếu đang ở trang login thì chuyển về home
        if (loginPaths.contains(currentPath)) return AppPaths.dashboard.path;
      } else {
        // Chưa login → nếu đang ở trang cần auth thì chuyển về login
        if (!loginPaths.contains(currentPath)) return AppPaths.login.path;
      }
      return null;
    },
    routes: [
      StatefulShellRoute(
        // navigationShell :current page is show
        navigatorContainerBuilder: (context, navigationShell, children) {
          return MainScreen(shell: navigationShell, children: children);
        },
        builder: (context, state, shell) {
          return shell;
        },
        // builder: (context, state, shell) {
        //   return MainScreen(shell: shell);
        // },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppPaths.dashboard.path,
                name: AppPaths.dashboard.pathName,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppPaths.creditPassed.path,
                name: AppPaths.creditPassed.pathName,
                builder: (context, state) => const CreditPassedScreen(),
                pageBuilder:
                    (context, state) =>
                        NoTransitionPage(key: state.pageKey, child: const CreditPassedScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppPaths.moreScreen.path,
                name: AppPaths.moreScreen.pathName,
                builder: (context, state) => const MoreScreen(),
                pageBuilder:
                    (context, state) =>
                        NoTransitionPage(key: state.pageKey, child: const MoreScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppPaths.login.path,
        name: AppPaths.login.pathName,
        builder: (context, state) => const LoginScreen(),
        pageBuilder:
            (context, state) => NoTransitionPage(key: state.pageKey, child: const LoginScreen()),
      ),
      // GoRoute(
      //   path: AppPaths.loginEmail.path,
      //   name: AppPaths.loginEmail.pathName,
      //   builder: (context, state) => const SignInDemo(),
      // ),
    ],
  );

  ref.onDispose(() => router.dispose());
  return router;
});
