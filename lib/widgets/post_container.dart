import 'package:dodecathlon/models/post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/user_details_screen.dart';

final formatter = DateFormat('yMMMMd').add_jm();

class PostContainer extends StatelessWidget {
  PostContainer({super.key, required this.post});

  Post post;

  @override
  Widget build(BuildContext context) {
    print(post.toString());
    return Container (
      margin: EdgeInsets.symmetric(vertical: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  post.user.profileImageUrl != null
                      ? post.user.profileImageUrl!
                      : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'
              ),
            ),
            title: Text(post.user.userName),
            subtitle: Text(formatter.format(post.createdAt)),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => UserDetailsScreen(user: post.user))
              );
            },
            trailing: IconButton(
                onPressed: () {

                },
                icon: Icon(Icons.more_vert)
            ),
          ),
          if (post.imageUrl !=  null)
            Image.network(post.imageUrl!, fit: BoxFit.fill,
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
          Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${post.user.userName} just ${post.title}', style: TextStyle(fontWeight: FontWeight.bold),),
                  if (post.description != null)
                    Text(post.description!)
                ],
              )
          ),
          Container(
            height: 40,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border)
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.comment)
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}