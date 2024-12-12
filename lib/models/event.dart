import 'package:dodecathlon/models/challenge.dart';
import 'package:flutter/material.dart';

class Event {

  final String name;
  final String description;
  final bool hasMultipleDifficulties;
  final Color themeColor;
  final IconData icon;
  final DateTime startDate;
  final DateTime endDate;
  final String displayImageUrl;
  final String? beginnerDescription;
  final String? intermediateDescription;
  final String? advancedDescription;
  final String? prize;
  final String? id;


  Event({
    required this.name,
    required this.description,
    required this.hasMultipleDifficulties,
    required this.themeColor,
    required this.icon,
    required this.startDate,
    required this.endDate,
    required this.displayImageUrl,
    this.beginnerDescription,
    this.intermediateDescription,
    this.advancedDescription,
    this.prize,
    this.id
  });
}