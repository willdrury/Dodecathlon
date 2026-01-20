import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/post.dart';
import 'package:dodecathlon/providers/challenges_provider.dart';
import 'package:dodecathlon/providers/events_provider.dart';
import 'package:dodecathlon/providers/posts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import '../models/submission.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('yMMMMd').add_jm();

class SubmissionDetailsScreen extends ConsumerStatefulWidget {
  SubmissionDetailsScreen({
    super.key,
    required this.submission,
  });

  Submission submission;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SubmissionDetailsScreenState();
  }
}

class _SubmissionDetailsScreenState extends ConsumerState<SubmissionDetailsScreen> {

  bool _showDetails = false;

  // Delete post confirmation modal
  Future<void> _dialogBuilder(BuildContext context, Post post) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Are you sure you want to delete this submission?'),
          content: const Text('Doing so will also delete any associated posts.'),
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
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Delete'),
              onPressed: () async {
                deletePost(post, context);
              },
            ),
          ],
        );
      },
    );
  }

  void deletePost(Post post, BuildContext ctx) async { // TODO: Show popup button and whatnot
    try {
      await post.delete();
      await widget.submission.delete();
      if (ctx.mounted) {
        Navigator.of(ctx).pop();
      }
    } catch (e) {
      print(e.toString());
      // TODO: logging
    }
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Post>> postStream = ref.watch(postsProvider);
    AsyncValue<List<Challenge>> challengeStream = ref.watch(challengesProvider);
    AsyncValue<List<Event>> eventStream = ref.watch(eventProvider);

    if (!postStream.hasValue || !challengeStream.hasValue || !eventStream.hasValue) {
      return Center(child: CircularProgressIndicator(),);
    }

    Post? post = postStream.value!.firstWhere((p) =>
      p.submissionId == widget.submission.id
    );
    Challenge? challenge = challengeStream.value!.firstWhere((c) =>
      c.id == widget.submission.challengeId
    );

    if (post == null || challenge == null) {
      // TODO: Logging
      return Center(child: CircularProgressIndicator(),);
    }

    Event? event = eventStream.value!.firstWhere((e) =>
      e.id == challenge.eventId
    );

    if (event == null) {
      // TODO: Logging
      return Center(child: CircularProgressIndicator(),);
    }

    return Scaffold(
      backgroundColor: Color.lerp(Colors.white, Theme.of(context).colorScheme.primaryContainer, 0.1),
      appBar: AppBar(
        title: Text('Submission Details'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Challenge',
                style: TextStyle(fontSize: 12),
              ),
              Text(
                challenge.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20,),
              Container(
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 5),
                        spreadRadius: 1,
                        blurRadius: 5
                    )
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (post.imageUrl != null)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 500,
                        ),
                        child: Image.network(
                          post.imageUrl!,
                          fit: BoxFit.fitWidth,
                          frameBuilder: (_, image, loadingBuilder, __) {
                            if (loadingBuilder == null) {
                              return const SizedBox(
                                height: 300,
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                            return image;
                          },
                          loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox(
                              height: 300,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (post.description != null)
                            Text(post.description!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      _dialogBuilder(context, post);
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    )
                  ),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        // TODO: Show popup
                      },
                      child: Text(
                        'Assign to User',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary
                        ),
                      )
                  )
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton.icon(
                  iconAlignment: IconAlignment.end,
                  onPressed: () {
                    setState(() {
                      _showDetails = !_showDetails;
                    });
                  },
                  label: Text(
                    'Details',
                  ),
                  icon: Icon(Icons.expand_more),
                ),
              ),
              if (_showDetails)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Is Approved:', style: TextStyle(fontWeight: FontWeight.bold),),
                          Spacer(),
                          Text(widget.submission.isApproved.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Points:', style: TextStyle(fontWeight: FontWeight.bold),),
                          Spacer(),
                          Text(widget.submission.points.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Submitted Date:', style: TextStyle(fontWeight: FontWeight.bold),),
                          Spacer(),
                          Text(formatter.format(widget.submission.createdDate)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Event:', style: TextStyle(fontWeight: FontWeight.bold),),
                          Spacer(),
                          Text(event.name),
                        ],
                      ),
                      SizedBox(height: 100,)
                    ],
                  ),
                ),
              SizedBox(height: 100,)
            ],
          ),
        ),
      ),
    );
  }
}