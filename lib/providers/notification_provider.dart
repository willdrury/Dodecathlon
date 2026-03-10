import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider = StreamProvider<List<Notification>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value([]);
  }
  return FirebaseFirestore.instance
      .collection('notifications')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => Notification.fromMap(doc.data()))
        .toList();
  });
});