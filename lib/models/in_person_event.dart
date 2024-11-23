import 'package:dodecathlon/models/user.dart';

class InPersonEvent {
  final String name;
  final String description;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final User host;
  List<User> attending;
  final String displayImageUrl;

  InPersonEvent({
    required this.name,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.host,
    required this.attending,
    required this.displayImageUrl,
  });

}