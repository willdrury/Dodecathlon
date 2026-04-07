import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/post.dart';
import '../../models/submission.dart';
import '../../models/user.dart';
import '../../providers/posts_provider.dart';
import '../../providers/submission_provider.dart';
import '../../providers/users_provider.dart';
import '../../screens/submission_approval_screen.dart';

class SubmissionAssignmentNotificationTemplate extends ConsumerWidget {
  const SubmissionAssignmentNotificationTemplate({
    super.key,
    required this.submissionId,
    required this.submissionUserName,
  });

  final String submissionId;
  final String submissionUserName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Post>> postStream = ref.watch(postsProvider);
    AsyncValue<List<Submission>> submissionsStream = ref.watch(submissionsProvider);
    AsyncValue<List<User>> usersStream = ref.watch(usersProvider);

    bool showNavigationButton = false;
    Post? post;
    Submission? submission;
    if (postStream.hasValue && submissionsStream.hasValue) {
      post = postStream.value!.where((p) => p.submissionId == submissionId).firstOrNull;
      submission = submissionsStream.value!.where((s) => s.id == submissionId).firstOrNull;
      if (post != null && usersStream.hasValue) {
        post.user = usersStream.value!.where((u) => u.id == post!.userId).firstOrNull;
        if (post.user != null) {
          showNavigationButton = true;
        }
      }
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('$submissionUserName assigned a submission to you for approval.'),
        SizedBox(height: 50,),
        if (showNavigationButton)
          FilledButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => SubmissionApprovalScreen(submission: submission!, post: post!))
              );
            },
            child: Text('View Submission')
          ),
        if (!showNavigationButton)
          Text('Unable to load submission', style: TextStyle(color: Colors.grey),),
      ]
    );
  }
}