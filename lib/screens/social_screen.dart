import 'package:dodecathlon/providers/posts_provider.dart';
import 'package:dodecathlon/providers/users_provider.dart';
import 'package:dodecathlon/widgets/post_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../models/user.dart';

class SocialScreen extends ConsumerStatefulWidget {
  const SocialScreen({super.key});

  @override
  ConsumerState<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends ConsumerState<SocialScreen> {

  @override
  Widget build(BuildContext context) {
    List<User> users = ref.watch(usersProvider);
    List<Post> posts = ref.watch(postsProvider);
    posts.sort((p1, p2) {
      if (p1.createdAt.isBefore(p2.createdAt)) {
        return 1;
      }
      return -1;
    });

    for (Post p in posts) {
      p.user = users.where((u) => u.id == p.userId).first;
    }

    return Scaffold(
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView.builder(
                    itemCount: posts.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, i) {
                      return PostContainer(post: posts[i]);
                    }
                ),
              ),
              SizedBox(height: 60,),
            ],
          ),
        ),
    );
  }
}