import 'package:dodecathlon/screens/notifications_screen.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({
    super.key,
    required this.label,
    required this.useShadow,
    required this.backgroundColor,
    required this.textColor,
    required this.hasUnread,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final bool useShadow;
  final bool hasUnread;

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
      shape: useShadow ? Border(bottom: BorderSide(color: Colors.black.withAlpha(20))) : null,
      elevation: useShadow ? 5.0 : 0,
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const NotificationsScreen())
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.notifications, color: Theme.of(context).colorScheme.onSurface,),
              if (hasUnread)
                Container(
                  height: 10,
                  width: 10,
                  margin: EdgeInsets.only(bottom: 15, left: 15),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
            ],
          ),
        ),
        IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.onSurface,)
        ),
      ],
    );
  }
}