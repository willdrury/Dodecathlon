import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventProvider = StreamProvider<List<Event>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value([]);
  }
  return FirebaseFirestore.instance
      .collection('events')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => Event.fromMap(doc.data(), doc.id))
        .toList();
  });
});