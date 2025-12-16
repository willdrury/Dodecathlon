import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider = StreamProvider<List<Notification>>((ref) {
  return FirebaseFirestore.instance
      .collection('notifications')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => Notification.fromMap(doc.data()))
        .toList();
  });
});