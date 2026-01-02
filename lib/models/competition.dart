import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Competition {

  final String name;
  final String description;
  final DateTime createdAt;
  final List<String> events;
  final Color themeColor;
  final String id;

  Competition({
    required this.name,
    required this.description,
    required this.createdAt,
    required this.events,
    required this.themeColor,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'createdAt': createdAt,
    'events': events,
    'themeColor': '#${themeColor.toARGB32().toRadixString(16)}',
  };

  factory Competition.fromMap(Map data, String id) {
    try {
      return Competition(
          name: data['name'],
          description: data['description'],
          createdAt: DateTime.fromMicrosecondsSinceEpoch((data['createdAt'] as Timestamp).microsecondsSinceEpoch),
          events: List<String>.from(data['events'] as List<dynamic>),
          themeColor: Color(int.parse(data['themeColor'].substring(1, 7), radix: 16)).withAlpha(255),
          id: id
      );
    } catch (e) {
      print('Error converting competition from JSON: ${e.toString()}');
    }
    throw Exception(); // TODO: Better exception handling, or handle somewhere else
  }

  Future<String?> upload() async {
    try {
      await FirebaseFirestore.instance.collection('competitions').doc(id).set(toJson());
    } catch (error) {
      return error.toString();
    }
    return null;
  }

  Future<String?> delete() async {
    try {
      await FirebaseFirestore.instance.collection('competitions').doc(id).delete();
    } catch (error) {
      return error.toString();
    }
    return null;
  }

}