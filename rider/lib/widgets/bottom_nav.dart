import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CurvedNavigationBar(
      index: currentIndex,
      height: 60,
      color: isDark ? Colors.grey[900]! : const Color.fromARGB(255, 0, 0, 0),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      buttonBackgroundColor:
          isDark ? Colors.blueGrey : const Color.fromARGB(255, 180, 181, 182),
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 300),
      onTap: onTap,
      items: [
        Icon(
          Icons.home,
          size: 30,
          color:
              isDark ? Colors.white : const Color.fromARGB(255, 255, 255, 255),
        ),
        Icon(
          Icons.search,
          size: 30,
          color:
              isDark ? Colors.white : const Color.fromARGB(255, 255, 255, 255),
        ),
        Icon(
          Icons.person,
          size: 30,
          color:
              isDark ? Colors.white : const Color.fromARGB(255, 255, 255, 255),
        ),
      ],
    );
  }
}
