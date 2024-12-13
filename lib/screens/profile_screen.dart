import 'package:dodecathlon/models/user.dart' as dd;
import 'package:dodecathlon/widgets/profile_details.dart';
import 'package:dodecathlon/widgets/profile_picture_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../providers/posts_provider.dart';
import '../providers/user_provider.dart';
import '../providers/users_provider.dart';
import '../widgets/post_container.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    dd.User currentUser = ref.watch(userProvider)!;
    List<Post> posts = ref.watch(postsProvider).where((p) =>
      p.userId == currentUser.id
    ).toList();

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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Container(
          color: Colors.black.withAlpha(7),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: TabBar(
                  tabs: <Widget>[
                    Tab(
                      text: 'Details',
                    ),
                    Tab(
                      text: 'Posts',
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
                            return PostContainer(post: posts[i]);
                          }
                        )
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