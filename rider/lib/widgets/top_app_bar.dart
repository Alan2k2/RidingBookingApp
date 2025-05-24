import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TopAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      elevation: 4,
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Opens the drawer
              },
            ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
