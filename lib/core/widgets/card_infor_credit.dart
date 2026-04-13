import 'package:exam/export.dart';
import 'package:flutter/material.dart';

class CardInforCreditWidget extends StatelessWidget {
  final String title;
  final String date;
  final String score;
  final VoidCallback? onPressed;

  const CardInforCreditWidget({
    Key? key,
    required this.title,
    required this.date,
    required this.score,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PressableWidget(
      onPressed: () {
        onPressed?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 4.w,
              children: [
                Text('Nội dung:', style: const TextStyle(fontSize: 10, color: Color(0xFF5E5E68))),
                Expanded(
                  child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date, style: const TextStyle(fontSize: 10, color: Color(0xFF5E5E68))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    score,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
