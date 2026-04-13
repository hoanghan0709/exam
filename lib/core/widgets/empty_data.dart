import 'package:exam/export.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 22.h,
        children: [
          Icon(LucideIcons.databaseSearch, color: context.colors.textSecondary, size: 80),
          Text(
            message ?? 'Bạn không thiếu tín chỉ nào!',
            style: context.textStyles.body.copyWith(color: context.colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
