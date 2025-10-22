import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/user.dart' as dd;

class UserProvider extends StateNotifier<dd.User?> {
  UserProvider() : super(null);

  Future<void> loadUser() async {
    print('loading user');
    if (FirebaseAuth.instance.currentUser == null) return;

    String uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    state = dd.User.fromMap(snapshot.data()!);
  }

  void setUser(dd.User user) async {
    user.currentEventPoints[0] = user.currentEventPoints[0].clamp(0, 100);
    user.currentCompetitionPoints[0] = user.currentCompetitionPoints[0].clamp(0, 100);
    state = user;
    await FirebaseFirestore.instance.collection('users').doc(user.id).set(user.toJson());
  }
}

final userProvider = StateNotifierProvider<UserProvider, dd.User?>((ref) {
  final provider = UserProvider();
  provider.loadUser();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore.instance.collection('users').doc(uid).snapshots().listen((data) {
    provider.loadUser();
  });
  return provider;
});