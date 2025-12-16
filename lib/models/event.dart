import 'package:flutter/material.dart';

import '../data/material_icon_map.dart';

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
  final String? mainChallengeId;
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
    this.mainChallengeId,
    this.id,
  });

  factory Event.fromMap(Map data, String id) {
    return Event(
        name: data['name'],
        description: data['description'],
        hasMultipleDifficulties: data['hasMultipleDifficulties'],
        themeColor: Color(int.parse(data['themeColor'].substring(1, 7), radix: 16)).withAlpha(255),
        icon: materialIconMap[data['icon']] ?? Icons.emoji_events,
        startDate: DateTime.parse((data['startDate'])),
        endDate: DateTime.parse((data['endDate'])),
        displayImageUrl: data['displayImageUrl'],
        beginnerDescription: data['beginnerDescription'],
        intermediateDescription: data['intermediateDescription'],
        advancedDescription: data['advancedDescription'],
        mainChallengeId: data['mainChallengeId'],
        id: id
    );
  }
}