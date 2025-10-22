import 'package:flutter/cupertino.dart';

class VerticalIconButton extends StatelessWidget {
  const VerticalIconButton({super.key, required this.icon, required this.label, required this.onPressed});
  
  final Icon icon;
  final String label;
  final VoidCallback onPressed;
  
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