import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart' as dd;

class UsersProvider extends AsyncNotifier<List<dd.User>> {
  @override
  FutureOr<List<dd.User>> build() async {
    return await loadUsers();
  }


  Future<List<dd.User>> loadUsers() async {
    print('loading users');
    var snapshots = await FirebaseFirestore.instance.collection('users').get();
    return snapshots.docs.map((snapshot) {
      return dd.User.fromMap(snapshot.data());
    }).toList();
  }
}

final usersProvider = AsyncNotifierProvider<UsersProvider, List<dd.User>>(UsersProvider.new);