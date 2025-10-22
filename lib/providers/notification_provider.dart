import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class NotificationProvider extends StateNotifier<List<Notification>> {
  NotificationProvider() : super([]);

  Future<void> loadNotifications() async {
    print('loading announcements');

    var snapshots = await FirebaseFirestore.instance.collection('notifications').get();
    state = snapshots.docs.map((snapshot) {
      return Notification.fromMap(snapshot.data());
    }).toList();
  }
}

final notificationProvider = StateNotifierProvider<NotificationProvider, List<Notification>>((ref) {
  final provider = NotificationProvider();
  provider.loadNotifications();
  FirebaseFirestore.instance.collection('notifications').snapshots().listen((event) {
    provider.loadNotifications();
  });
  return provider;
});