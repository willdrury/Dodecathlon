import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/post.dart';
import 'package:dodecathlon/models/submission.dart';
import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubmissionProvider extends StateNotifier<List<Submission>> {
  SubmissionProvider() : super([]);

  Future<void> loadSubmissions(List<String> submissions, String userId) async {
    print('loading submissions');

    final querySnapshot = await FirebaseFirestore.instance.collection('submissions')
        .where('id', whereIn: submissions)
        .where('userId', isEqualTo: userId)
        .get();
    state = querySnapshot.docs.map((snapshot) => Submission.fromMap(snapshot.data()!)).toList();
  }
}

final submissionsProvider = StateNotifierProvider<SubmissionProvider, List<Submission>>((ref) {
  User user = ref.watch(userProvider)!;
  final provider = SubmissionProvider();
  provider.loadSubmissions(user.submissions, user.id!);
  FirebaseFirestore.instance.collection('submissions').snapshots().listen((event) {
    provider.loadSubmissions(user.submissions, user.id!);
  });
  return provider;
});