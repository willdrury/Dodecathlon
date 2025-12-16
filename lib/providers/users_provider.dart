import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart' as dd;

final usersProvider = StreamProvider<List<dd.User>>((ref) {
  return FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => dd.User.fromMap(doc.data()))
        .toList();
  });
});