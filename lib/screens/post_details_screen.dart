import 'dart:math';

import 'package:dodecathlon/models/challenge.dart';
import 'package:dodecathlon/models/post.dart';
import 'package:dodecathlon/models/post_comment.dart';
import 'package:dodecathlon/providers/post_comments_provider.dart';
import 'package:dodecathlon/providers/users_provider.dart';
import 'package:dodecathlon/widgets/post_comment_details_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';

final formatter = DateFormat('EEE, MMM d, hh:mm');


class PostDetailsScreen extends ConsumerWidget {
  const PostDetailsScreen({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<PostComment>> commentsStream = ref.watch(postCommentsProvider);
    AsyncValue<List<User>> users = ref.watch(usersProvider);

    if (!users.hasValue || !commentsStream.hasValue) {
      return Center(child: CircularProgressIndicator(),);
    }

    List<PostComment> comments = commentsStream.value!.where((c) =>
      c.postId == post.id
    ).toList();
    
    List<User> likedUsers = users.value!.where((u) => 
      post.likes.contains(u.id)
    ).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.imageUrl != null)
            Hero(
              tag: post.id,
              child: Image.network(post.imageUrl!, fit: BoxFit.fitWidth, height: 150, width: double.infinity,),
            ),
          Expanded(
            child:
            SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '${post.user!.userName}  |  ${formatter.format(post.createdAt)}',
                      style: TextStyle(
                        color: Colors.grey
                      ),
                    ),
                    SizedBox(height: 10,),
                    if (likedUsers.isNotEmpty)
                      Container(
                        child: Text(
                          'Liked by:',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10
                          ),
                        ),
                      ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (likedUsers.isNotEmpty)
                          Expanded(
                            child: Stack(
                              children: [
                                for (int i = 0; i < min(likedUsers.length, 7); i++)
                                  Container(
                                    margin: EdgeInsets.only(left: i * 30),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: Colors.white
                                          ),
                                        ),
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                            likedUsers[i].profileImageUrl != null
                                              ? likedUsers[i].profileImageUrl!
                                              : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (likedUsers.length >= 7)
                                  Container(
                                    margin: EdgeInsets.only(left: 230, top: 20),
                                    alignment: Alignment.bottomLeft,
                                    child: Text('...')
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Text(post.description!),
                    SizedBox(height: 20,),
                    if (comments.isEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          SizedBox(height: 20,),
                          Text(
                            'Be the first to leave a comment!',
                            style: TextStyle(color: Colors.black26),
                          ),
                        ],
                      ),
                    ListView.builder(
                        itemCount: comments.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, i) {

                          User? commentUser = users.value!.where((u) =>
                            u.id == comments[i].userId
                          ).firstOrNull;

                          if (commentUser == null) {
                            return Container(
                              height: 10,
                              color: Colors.pink,
                            );
                          }

                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      commentUser.profileImageUrl != null
                                          ? commentUser.profileImageUrl!
                                          : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      commentUser.userName,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10
                                      ),
                                    ),
                                    Text(comments[i].body),
                                    Icon(
                                      Icons.favorite_outline,
                                      size: 20,
                                    )
                                  ],
                                ),
                                Spacer(),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.more_vert)
                                )
                              ],
                            ),
                          );
                        }
                    ),
                  ],
                ),
              ),
            ),
          ),
          PostCommentDetailsFooter(post: post)
        ],
      ),
    );
  }
}