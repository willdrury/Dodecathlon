import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/competition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final competitionProvider = StreamProvider<List<Competition>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value([]);
  }
  return FirebaseFirestore.instance
      .collection('competitions')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => Competition.fromMap(doc.data(), doc.id))
        .toList();
  });
});