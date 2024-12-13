import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/user.dart';

class InPersonEvent {
  final String name;
  final String description;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final String host;
  List<String> attending;
  final String displayImageUrl;
  final String id;

  InPersonEvent({
    required this.name,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.host,
    required this.attending,
    required this.displayImageUrl,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'location': location,
    'startTime': startTime,
    'endTime': endTime,
    'host': host,
    'attending': attending,
    'displayImageUrl': displayImageUrl,
  };

  factory InPersonEvent.fromMap(Map data, String id) {
    return InPersonEvent(
        name: data['name'],
        description: data['description'],
        location: data['location'],
        startTime: DateTime.fromMicrosecondsSinceEpoch((data['startTime'] as Timestamp).microsecondsSinceEpoch),
        endTime: DateTime.fromMicrosecondsSinceEpoch((data['endTime'] as Timestamp).microsecondsSinceEpoch),
        host: data['host'],
        attending: List<String>.from(data['attending'] as List<dynamic>),
        displayImageUrl: data['displayImageUrl'],
        id: id
    );
  }

  Future<String?> upload() async {
    try {
      await FirebaseFirestore.instance.collection('inPersonEvents').doc(id).set(toJson());
    } catch (error) {
      return error.toString();
    }
  }

}