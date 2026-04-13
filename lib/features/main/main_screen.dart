import 'package:exam/export.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MainScreen extends ConsumerWidget {
  final StatefulNavigationShell shell;

  const MainScreen({super.key, required this.shell, this.onTabChanged});

  final ValueChanged<int>? onTabChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonScaffold(
      body: shell,
      extendBody: false,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: shell.currentIndex,
        onTabChanged: (index) {
          shell.goBranch(index, initialLocation: index == shell.currentIndex);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.house),
            label: 'Trang chủ',
            backgroundColor: Colors.red,
            activeIcon: Icon(LucideIcons.house, color: Colors.white),
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.listChecks),
            label: 'Tín chỉ đạt',
            backgroundColor: Colors.red,
            activeIcon: Icon(LucideIcons.listChecks, color: Colors.white),
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.userRound),
            label: 'Thông tin',
            backgroundColor: Colors.red,
            activeIcon: Icon(LucideIcons.userRound, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
