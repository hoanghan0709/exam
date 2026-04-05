//create class customem bottom navigation bar
import 'package:exam/common_widgets/common_pressable.dart';
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

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      decoration:
          isActive
              ? BoxDecoration(
                color: const Color(0xFF545C8C),
                borderRadius: BorderRadius.circular(40),
              )
              : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isActive ? activeIcon : icon,
          ...[
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
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
