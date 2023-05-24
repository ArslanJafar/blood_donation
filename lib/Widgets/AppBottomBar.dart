import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class AppBottomBar extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;
  const AppBottomBar({Key? key, required this.onTap, required this.currentIndex}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  ConvexAppBar(
      initialActiveIndex: currentIndex,
      style: TabStyle.reactCircle,
      items: [
        TabItem(icon: Icons.person_2, title: 'Donner'),
        TabItem(icon: Icons.bloodtype, title: 'Requests'),
        TabItem(icon: Icons.settings, title: 'Settings'),

      ],
      onTap: onTap,
    );
  }
}
