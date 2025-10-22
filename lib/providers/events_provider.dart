import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventsProvider extends StateNotifier<List<Event>> {
  EventsProvider() : super([]);

  Future<void> loadEvents() async {
    print('loading events');

    try {
      var snapshots = await FirebaseFirestore.instance.collection('events').get();
      state = snapshots.docs.map((snapshot) {
        return Event.fromMap(snapshot.data(), snapshot.id);
      }).toList();
    } catch (e) {
      print('error loading events: ${e.toString()}');
    }
  }
}

final eventProvider = StateNotifierProvider<EventsProvider, List<Event>>((ref) {
  final provider = EventsProvider();
  provider.loadEvents();
  FirebaseFirestore.instance.collection('events').snapshots().listen((event) {
    provider.loadEvents();
  });
  return provider;
});