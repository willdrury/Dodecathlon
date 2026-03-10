import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/announcement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final announcementProvider = StreamProvider<List<Announcement>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value([]);
  }
  return FirebaseFirestore.instance
      .collection('announcements')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => Announcement.fromMap(doc.data()))
        .toList();
  });
});