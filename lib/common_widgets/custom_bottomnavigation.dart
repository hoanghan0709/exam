import 'dart:ui';

import 'package:exam/export.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final List<BottomNavigationBarItem> items;
  final PageController? pageController;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    this.items = const [],
    this.pageController,
  });

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentIndex.toDouble();
    widget.pageController?.addListener(_onPageScroll);
  }

  @override
  void didUpdateWidget(covariant CustomBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageController != widget.pageController) {
      oldWidget.pageController?.removeListener(_onPageScroll);
      widget.pageController?.addListener(_onPageScroll);
    }
    // Nếu không có pageController thì fallback theo currentIndex
    if (widget.pageController == null && oldWidget.currentIndex != widget.currentIndex) {
      setState(() {
        _currentPage = widget.currentIndex.toDouble();
      });
    }
  }

  @override
  void dispose() {
    widget.pageController?.removeListener(_onPageScroll);
    super.dispose();
  }

  void _onPageScroll() {
    final page = widget.pageController?.page;
    if (page != null) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 60.h,
        margin: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom + 16.h),
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: context.colors.cardBackground,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: context.colors.textPrimary.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < widget.items.length; i++)
              InkWell(
                onTap: () => widget.onTabChanged(i),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: _buildNavItem(
                  widget.items[i].icon,
                  widget.items[i].activeIcon,
                  widget.items[i].label ?? "",
                  i,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(Widget icon, Widget activeIcon, String label, int index) {
    // Tính mức độ active dựa trên khoảng cách đến _currentPage
    final double distance = (_currentPage - index).abs();
    final double activeRatio = (1.0 - distance).clamp(0.0, 1.0);

    final double scale = 0.85 + (0.1 * activeRatio);
    final bool showActive = activeRatio > 0.5;

    return Transform.scale(
      scale: scale,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: lerpDouble(1.w, 14.w, activeRatio)!,
          vertical: 6.h,
        ),
        decoration: BoxDecoration(
          color: Color.lerp(Colors.transparent, context.colors.primary, activeRatio),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child:
                  showActive
                      ? KeyedSubtree(key: const ValueKey('active'), child: activeIcon)
                      : KeyedSubtree(key: const ValueKey('inactive'), child: icon),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              child:
                  showActive
                      ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                      )
                      : Text(
                        label,
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
