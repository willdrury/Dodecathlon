import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/challenge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final challengesProvider = StreamProvider<List<Challenge>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value([]);
  }
  return FirebaseFirestore.instance
      .collection('challenges')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => Challenge.fromMap(doc.data(), doc.id))
        .toList();
  });
});

// TODO implement this provider and create new class "UserChallenges" to hold all groupings of challanges.
// final userChallengesProvider = Provider<List<UserChallenges>>((ref) {
//   final challengesAsync = ref.watch(challengesProvider);
//
//   // Use .maybeWhen or .when to handle the asynchronous states
//   // We return an empty list for loading/error to satisfy your "non-async" requirement
//   return challengesAsync.maybeWhen(
//     data: (challenges) => challenges.where((challenge) => challenge.isBonus).toList(),
//     orElse: () => [],
//   );
// });