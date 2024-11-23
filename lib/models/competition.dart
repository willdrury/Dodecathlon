import 'package:dodecathlon/models/event.dart';

class Competition {

  final String name;
  final List<Event> events;

  Competition({
    required this.name,
    required this.events,
  });

}