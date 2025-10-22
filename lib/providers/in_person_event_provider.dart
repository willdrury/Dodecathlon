import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/in_person_event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class InPersonEventProvider extends StateNotifier<List<InPersonEvent>> {
  InPersonEventProvider() : super([]);

  Future<void> loadEvents() async {
    print('loading in-person events');

    var snapshots = await FirebaseFirestore.instance.collection('inPersonEvents').get();
    state = snapshots.docs.map((snapshot) {
      return InPersonEvent.fromMap(snapshot.data(), snapshot.id);
    }).toList();
  }
}

final inPersonEventProvider = StateNotifierProvider<InPersonEventProvider, List<InPersonEvent>>((ref) {
  final provider = InPersonEventProvider();
  provider.loadEvents();
  FirebaseFirestore.instance.collection('inPersonEvents').snapshots().listen((event) {
    provider.loadEvents();
  });
  return provider;
});