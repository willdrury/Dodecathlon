import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/announcement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AnnouncementProvider extends StateNotifier<List<Announcement>> {
  AnnouncementProvider() : super([]);

  Future<void> loadAnnouncements() async {
    print('loading announcements');

    var snapshots = await FirebaseFirestore.instance.collection('announcements').get();
    state = snapshots.docs.map((snapshot) {
      print(snapshot.data());
      return Announcement.fromMap(snapshot.data());
    }).toList();
  }
}

final announcementProvider = StateNotifierProvider<AnnouncementProvider, List<Announcement>>((ref) {
  final provider = AnnouncementProvider();
  provider.loadAnnouncements();
  FirebaseFirestore.instance.collection('announcements').snapshots().listen((event) {
    provider.loadAnnouncements();
  });
  return provider;
});