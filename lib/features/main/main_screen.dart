import 'package:exam/common_widgets/custom_bottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends ConsumerWidget {
  final StatefulNavigationShell shell;

  const MainScreen({super.key, required this.shell, this.onTabChanged});

  final ValueChanged<int>? onTabChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: shell,
      extendBody: true,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: shell.currentIndex,
        onTabChanged: (index) {
          shell.goBranch(index, initialLocation: index == shell.currentIndex);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
            backgroundColor: Colors.red,
            activeIcon: Icon(Icons.home, color: Colors.white),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'Lịch trình\n kết quả',
          //   backgroundColor: Colors.red,
          //   activeIcon: Icon(Icons.person, color: Colors.white),
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.red,
            activeIcon: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
