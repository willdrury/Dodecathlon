import 'package:dodecathlon/providers/posts_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/providers/users_provider.dart';
import 'package:dodecathlon/screens/social_search_screen.dart';
import 'package:dodecathlon/widgets/post_container.dart';
import 'package:dodecathlon/widgets/social_filters_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../models/submission.dart';
import '../models/user.dart';
import '../providers/submission_provider.dart';

class SocialScreen extends ConsumerStatefulWidget {
  const SocialScreen({super.key});

  @override
  ConsumerState<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends ConsumerState<SocialScreen> {
  List<String> activeFilters = [];

  @override
  Widget build(BuildContext context) {
    User? currentUser = ref.watch(userProvider);
    AsyncValue<List<User>> users = ref.watch(usersProvider);
    AsyncValue<List<Post>> postStream = ref.watch(postsProvider);
    AsyncValue<List<Submission>> submissions = ref.watch(submissionsProvider);

    if (!postStream.hasValue || currentUser == null) {
      return Center(child: CircularProgressIndicator(),);
    }

    List<Post> posts = postStream.value!;
    posts.sort((p1, p2) {
      if (p1.createdAt.isBefore(p2.createdAt)) {
        return 1;
      }
      return -1;
    });

    Map<Post, Submission?> submissionsMap = {};
    if (users.hasValue) {
      for (Post p in posts) {
        p.user = users.value!.where((u) => u.id == p.userId).first;
        if (p.submissionId != null) {
          submissionsMap[p] = submissions.value!.where((s) =>
            s.id == p.submissionId
          ).firstOrNull;
        }
      }
    }

    void applyFilter(String filterName) { // TODO: implement sorting
      setState(() {
        switch (filterName) {
          case 'Friends':
            posts = posts.where((p) =>
                currentUser!.friends.contains(p.userId)
            ).toList();
          case 'Requires Approval':
            posts = posts.where((p) =>
              submissionsMap[p] != null && submissionsMap[p]!.isApproved == false
            ).toList();
          case 'Event Submissions':
            posts = posts.where((p) =>
              submissionsMap[p] != null
            ).toList();
          case 'Non-Event Submissions':
            posts = posts.where((p) =>
              submissionsMap[p] == null
            ).toList();
        }
      });
    }

    for (String s in activeFilters) {
      applyFilter(s);
    }

    void toggleFilter(String s) {
      setState(() {
        if (activeFilters.contains(s)) {
          activeFilters.remove(s);
        } else {
          activeFilters.add(s);
        }
      });
    }

    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                  SocialSearchScreen()
                ));
              },
              child: Container(
                margin: EdgeInsets.only(top: 20, right: 20, left: 20),
                padding: EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.black38)
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.black38,),
                    SizedBox(width: 10,),
                    Text('Find Users', style: TextStyle(color: Colors.black38),),
                  ],
                ),
              ),
            ),
            SocialFiltersCarousel(toggleFilter: toggleFilter),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child:
                  posts.isEmpty
                  ? Container(
                      height: 300,
                      child: Center(
                          child: Text('Looks like theres nothing here...')
                      )
                  )
                  : ListView.builder(
                    itemCount: posts.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, i) {
                      return PostContainer(post: posts[i], submission: submissionsMap[posts[i]],);
                    }
                ),
              ),
            ),
            SizedBox(height: 60,),
          ],
        ),
      ),
    );
  }
}