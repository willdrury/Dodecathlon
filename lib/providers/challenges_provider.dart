import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/challenge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final challengesProvider = StreamProvider<List<Challenge>>((ref) {
  return FirebaseFirestore.instance
      .collection('challenges')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => Challenge.fromMap(doc.data(), doc.id))
        .toList();
  });
});