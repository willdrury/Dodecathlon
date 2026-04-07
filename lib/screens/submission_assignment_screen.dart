import 'package:dodecathlon/models/post.dart';
import 'package:dodecathlon/providers/posts_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/submission.dart';
import '../models/user.dart';
import '../models/notification.dart' as dd;

Uuid uuid = Uuid();

class SubmissionAssignmentScreen extends ConsumerStatefulWidget {
  SubmissionAssignmentScreen({
    super.key,
    required this.submission,
  });

  Submission submission;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SubmissionAssignmentScreenState();
  }
}

class _SubmissionAssignmentScreenState extends ConsumerState<SubmissionAssignmentScreen> {

  late TextEditingController _searchController;
  User? assignedUser;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmAssignmentDialogBuilder(BuildContext context, User currentUser) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Assign ${assignedUser!.userName} to this submission?'),
          content: const Text('Doing so will send the user a notification to review the submission. Other '
              'users will be able to view and approve the submission, but you will be unable to assign another user'
              'for 24 hours.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Confirm'),
              onPressed: () async {
                widget.submission.approverId = assignedUser!.id;
                widget.submission.approverAddedAt = DateTime.now();
                await widget.submission.upload(); // TODO: Error handling

                dd.Notification notification = dd.Notification(
                  title: 'Submission Assignment',
                  body: 'You have been assigned a submission for approval.',
                  user: assignedUser!.id!,
                  createdAt: DateTime.now(),
                  isRead: false,
                  id: uuid.v4(),
                  template: dd.NotificationTemplate.submissionAssignment,
                  templateData: {
                    'submissionId': widget.submission.id,
                    'submissionUserName': currentUser.userName,
                  }
                );
                await notification.upload(); // TODO: Error handling

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Post>> postStream = ref.watch(postsProvider);
    AsyncValue<List<User>> usersStream = ref.watch(usersProvider);
    AsyncValue<User?> userStream = ref.watch(userProvider);
    if (!userStream.hasValue) {
      return const Center(child: CircularProgressIndicator(),);
    }

    User currentUser = userStream.value!;

    if (!postStream.hasValue || !usersStream.hasValue) {
      return (Center(child: CircularProgressIndicator(),));
    }

    List<User> filteredUsers = usersStream.value!.where((u) =>
      u.id != currentUser.id &&
      currentUser.friends.contains(u.id) &&
      u.userName.toLowerCase().contains(_searchController.text.toLowerCase())
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Assign to user'
          ),
          onChanged: (value) {
            setState(() {

            });
          },
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop<User>(assignedUser);
          },
          icon: Icon(Icons.arrow_back)
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            if (filteredUsers.isEmpty)
              Text('No users found', style: TextStyle(color: Colors.grey),),
            ListView.builder(
              shrinkWrap: true,
              itemCount: filteredUsers.length,
              itemBuilder: (ctx, i) {
                return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          filteredUsers[i].profileImageUrl != null
                              ? filteredUsers[i].profileImageUrl!
                              : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'
                      ),
                    ),
                    title: Text(filteredUsers[i].userName),
                    onTap: () async {
                      assignedUser = filteredUsers[i];
                      await _confirmAssignmentDialogBuilder(context, currentUser);
                      if (context.mounted) Navigator.of(context).pop<User>();
                    },
                );
              }
            )
          ],
        ),
      )
    );
  }
}