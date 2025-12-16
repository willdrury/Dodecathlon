import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/in_person_event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final inPersonEventProvider = StreamProvider<List<InPersonEvent>>((ref) {
  return FirebaseFirestore.instance
      .collection('inPersonEvents')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => InPersonEvent.fromMap(doc.data(), doc.id)).toList();
  });
});