import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventProvider = StreamProvider<List<Event>>((ref) {
  return FirebaseFirestore.instance
      .collection('events')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => Event.fromMap(doc.data(), doc.id))
        .toList();
  });
});