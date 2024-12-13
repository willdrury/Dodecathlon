import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CircularProgressContainer extends StatefulWidget {
  CircularProgressContainer({
    super.key,
    required this.currentPoints,
    required this.maxPoints,
    required this.circleColor,
    required this.indicatorColor,
    required this.upperTextColor,
    required this.lowerTextColor,
    required this.circleDiameter,
    required this.indicatorDiameter,
    required this.indicatorWidth,
    required this.indicatorProgress,
    required this.fontSize,
  });

  final int currentPoints;
  final int maxPoints;
  final Color circleColor;
  final Color indicatorColor;
  final Color upperTextColor;
  final Color lowerTextColor;
  final double circleDiameter;
  final double indicatorDiameter;
  final double indicatorWidth;
  final double indicatorProgress;
  final double fontSize;

  @override
  State<StatefulWidget> createState() {
    return _CircularProgressContainerState();
  }
}

class _CircularProgressContainerState extends State<CircularProgressContainer> with TickerProviderStateMixin {
  late AnimationController controller;
  late CurvedAnimation animation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
      setState(() {});
    });
    controller.forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.ease);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BoxShadow> shadows = [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0, 5),
        spreadRadius: 1,
        blurRadius: 5
      )
    ];

    return SizedBox(
      height: widget.indicatorDiameter,
      width: widget.indicatorDiameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container( // Indicator
            height: widget.indicatorDiameter,
            width: widget.indicatorDiameter,
            child:  CircularProgressIndicator(
              value: animation.value * widget.indicatorProgress,
              strokeWidth: widget.indicatorWidth,
              strokeCap: StrokeCap.round,
              color: widget.indicatorColor,
            ),
          ),
          Container( // Inner cirlce
            height: widget.circleDiameter,
            width: widget.circleDiameter,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.circleColor,
                boxShadow: shadows,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${widget.currentPoints}',
                  style: GoogleFonts.shareTech(
                      color: widget.upperTextColor,
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.bold,
                      shadows: shadows,
                      height: .95
                  ),
                ),
                Text(
                  'of ${widget.maxPoints}',
                  style: GoogleFonts.shareTech(
                      color: widget.lowerTextColor,
                      fontSize: widget.fontSize/4,
                      height: 0.7,
                      shadows: shadows
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}