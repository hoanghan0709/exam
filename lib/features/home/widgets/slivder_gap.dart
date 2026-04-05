import 'package:flutter/material.dart';

class SliverGap extends StatelessWidget {
  final double height;
  const SliverGap(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: SizedBox(height: height));
  }
}
