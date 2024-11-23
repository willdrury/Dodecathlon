import 'package:flutter/cupertino.dart';

class VerticalIconButton extends StatelessWidget {
  VerticalIconButton({super.key, required this.icon, required this.label, required this.onPressed});
  
  Icon icon;
  String label;
  VoidCallback onPressed;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          icon,
          Text(label)
        ],
      ),
    );
  }
}