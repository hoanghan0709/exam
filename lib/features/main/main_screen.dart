import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exam/export.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MainScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell shell;

  const MainScreen({super.key, required this.shell, this.onTabChanged, required this.children});

  final ValueChanged<int>? onTabChanged;
  final List<Widget> children;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  //define controller
  late final PageController _pageController = PageController(
    initialPage: widget.shell.currentIndex,
  );
  bool isScrolling = false;
  //create initState
  @override
  void initState() {
    super.initState();
    _pageController.addListener(onScroll);
  }

  //create dispose
  @override
  void dispose() {
    _pageController.removeListener(onScroll);
    _pageController.dispose();
    super.dispose();
  }

  void onScroll() {
    if (isScrolling) return;
    final newIndex = _pageController.page?.round();
    if (newIndex != null && newIndex != widget.shell.currentIndex) {
      widget.shell.goBranch(newIndex);
    }
  }

  @override
  void didUpdateWidget(covariant MainScreen oldWidget) {
    if (oldWidget.shell.currentIndex != widget.shell.currentIndex) {
      isScrolling = true;
      _pageController
          .animateToPage(
            widget.shell.currentIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          )
          .whenComplete(() => isScrolling = false);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      body: PageView(
        // physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: widget.children,
      ),
      extendBody: true,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: widget.shell.currentIndex,
        pageController: _pageController,
        onTabChanged: (index) {
          widget.shell.goBranch(index, initialLocation: index == widget.shell.currentIndex);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.house, color: context.colors.textSecondary),
            label: 'Trang chủ',
            backgroundColor: context.colors.error,
            activeIcon: Icon(LucideIcons.house, color: Colors.white),
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.listChecks, color: context.colors.textSecondary),
            label: 'Tín chỉ đạt',
            backgroundColor: context.colors.error,
            activeIcon: Icon(LucideIcons.listChecks, color: Colors.white),
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.userRound, color: context.colors.textSecondary),
            label: 'Thông tin',
            backgroundColor: context.colors.error,
            activeIcon: Icon(LucideIcons.userRound, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
