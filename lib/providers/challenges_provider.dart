import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/challenge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChallengesProvider extends AsyncNotifier<List<Challenge>> {
  @override
  FutureOr<List<Challenge>> build() async {
    return await loadChallenges();
  }

  Future<List<Challenge>> loadChallenges() async {
    print('loading challenges');

    try {
      var snapshots = await FirebaseFirestore.instance.collection('challenges').get();
      return snapshots.docs.map((snapshot) {
        return Challenge.fromMap(snapshot.data(), snapshot.id);
      }).toList();
    } catch (e, s) {
      print('error loading challenges: ${e.toString()} \n $s');
    }
    return [];
  }
}

final challengesProvider = AsyncNotifierProvider<ChallengesProvider, List<Challenge>>(ChallengesProvider.new);