import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart' as dd;

class UsersProvider extends StateNotifier<List<dd.User>> {
  UsersProvider() : super([]);

  Future<void> loadUsers() async {
    print('loading users');
    if (state != null && state.isNotEmpty) {
      print('already loaded users');
      return;
    }

    var snapshots = await FirebaseFirestore.instance.collection('users').get();
    state = snapshots.docs.map((snapshot) {
      return dd.User.fromMap(snapshot.data());
    }).toList();
  }
}

final usersProvider = StateNotifierProvider<UsersProvider, List<dd.User>>((ref) {
  final provider = UsersProvider();
  provider.loadUsers();
  return provider;
});