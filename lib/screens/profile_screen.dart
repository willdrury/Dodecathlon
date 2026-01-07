import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/event.dart';
import 'package:dodecathlon/models/user.dart' as dd;
import 'package:dodecathlon/providers/challenges_provider.dart';
import 'package:dodecathlon/providers/events_provider.dart';
import 'package:dodecathlon/widgets/profile_details.dart';
import 'package:dodecathlon/widgets/submission_tile_medium.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../models/submission.dart';
import '../providers/posts_provider.dart';
import '../providers/submission_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/post_container.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    dd.User currentUser = ref.watch(userProvider)!;
    AsyncValue<List<Submission>> userSubmissions = ref.watch(submissionsProvider);
    AsyncValue<List<Challenge>> challenges = ref.watch(challengesProvider);
    AsyncValue<List<Event>> events = ref.watch(eventProvider);
    AsyncValue<List<Post>> postStream = ref.watch(postsProvider);

    Map<Event, List<(Submission, Challenge)>> eventMap = {};
    Map<Post, Submission?> submissionsMap = {};

    if (challenges.hasValue && events.hasValue && userSubmissions.hasValue) {
      userSubmissions.value!.sort((a,b) =>
        a.createdDate.isBefore(b.createdDate) ? 1 : 0
      );
      for (Submission s in userSubmissions.value!) {
        Challenge? c = challenges.value!.where((e) => e.id == s.challengeId).firstOrNull;
        if (c == null) continue;

        Event? e = events.value!.where((e1) => e1.id == c.eventId).firstOrNull;
        if (e == null) continue;

        if (eventMap.containsKey(e!)) {
          eventMap[e]!.add((s, c));
        } else {
          eventMap[e] = [(s,c)];
        }
      }
    }

    List<Post> posts = [];
    if (postStream.hasValue) {
      for (Post p in postStream.value!) {
        if (p.userId == currentUser.id) {
          posts.add(p);
          if (p.submissionId != null) {
            submissionsMap[p] = userSubmissions.value!.where((s) =>
              s.id == p.submissionId
            ).firstOrNull;
          }
        }
      }
    }

    posts.sort((p1, p2) {
      if (p1.createdAt.isBefore(p2.createdAt)) {
        return 1;
      }
      return -1;
    });

    for (Post p in posts) {
      p.user = currentUser;
    }

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Container(
          color: Colors.black.withAlpha(7),
          child: Column(
            children: [
              Container(
                color: Theme.of(context).colorScheme.surface,
                child: TabBar(
                  tabs: <Widget>[
                    Tab(
                      text: 'Details',
                    ),
                    Tab(
                      text: 'Posts',
                    ),
                    Tab(
                      text: 'Submissions',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ProfileDetails(),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: ListView.builder(
                          itemCount: posts.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, i) {
                            return PostContainer(post: posts[i], submission: submissionsMap[posts[i]],);
                          }
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: userSubmissions.hasValue && challenges.hasValue && events.hasValue
                        ? SingleChildScrollView(
                          child: ListView.builder(
                            itemCount: eventMap.keys.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, i) {
                              List<(Submission, Challenge)> subs = eventMap[eventMap.keys.toList()[i]]!;
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    child: Text(
                                      eventMap.keys.toList()[i].name,
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                  ),
                                  ListView.builder(
                                    itemCount: subs.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (ctx2, j) {
                                      return SubmissionTileMedium(submission: subs[j].$1, challenge: subs[j].$2,);
                                    }
                                  )
                                ],
                              );
                            }
                          )
                        )
                        : Center(
                          child: Text('Complete your first challenge to get started!'),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}