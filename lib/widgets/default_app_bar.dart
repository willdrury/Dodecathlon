import 'package:dodecathlon/screens/notifications_screen.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({
    super.key,
    required this.label,
    required this.useShadow,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final bool useShadow;

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(label, style: TextStyle(color: textColor),),
      iconTheme: IconThemeData(color: textColor),
      floating: true,
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black26,
      shape: useShadow ? Border.all(color: Colors.black.withAlpha(20)) : null,
      elevation: useShadow ? 5.0 : 0,
      actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const NotificationsScreen())
              );
            },
            icon: Icon(Icons.notifications)
        ),
        IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: Icon(Icons.menu)
        ),
      ],
    );
  }
}