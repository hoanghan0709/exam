import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final List<BottomNavigationBarItem> items;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    this.items = const [],
  });

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.value = 1.0; // Bắt đầu ở trạng thái hoàn thành
  }

  @override
  void didUpdateWidget(covariant CustomBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _controller.forward(from: 0.0); // Chạy animation khi đổi tab
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < widget.items.length; i++)
            InkWell(
              onTap: () => widget.onTabChanged(i),
              child: _buildNavItem(
                widget.items[i].icon,
                widget.items[i].activeIcon,
                widget.items[i].label ?? "",
                i == widget.currentIndex,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavItem(Widget icon, Widget activeIcon, String label, bool isActive) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double scale = isActive ? 0.85 + (0.1 * _animation.value) : 0.85;
        final double opacity = isActive ? 0.5 + (0.5 * _animation.value) : 1.0;
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(horizontal: isActive ? 14.w : 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF545C8C) : Colors.transparent,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOutBack,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child:
                        isActive
                            ? KeyedSubtree(key: const ValueKey('active'), child: activeIcon)
                            : KeyedSubtree(key: const ValueKey('inactive'), child: icon),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    child:
                        isActive
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
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
