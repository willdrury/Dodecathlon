import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/announcement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final announcementProvider = StreamProvider<List<Announcement>>((ref) {
  return FirebaseFirestore.instance
      .collection('announcements')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => Announcement.fromMap(doc.data()))
        .toList();
  });
});