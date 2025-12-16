import 'package:flutter/material.dart';

class BoxShadows {
  static const BoxShadow defaultShadow = BoxShadow(
      color: Colors.black12,
      offset: Offset(0, 5),
      spreadRadius: 1,
      blurRadius: 5
  );

  static const List<BoxShadow> cardShadow = [
    defaultShadow
  ];
}