import 'package:dodecathlon/models/post.dart';
import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../screens/user_details_screen.dart';

final formatter = DateFormat('yMMMMd').add_jm();

class PostContainer extends ConsumerStatefulWidget {
  const PostContainer({super.key, required this.post});

  final Post post;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PostContainerState();
  }
}

class _PostContainerState extends ConsumerState<PostContainer> {

  Future<void> _dialogBuilder(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete this post?'),
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
                String? error = await widget.post.delete();
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = ref.read(userProvider)!;
    bool _isLiked = user.likedPostIds.contains(widget.post.id);

    return Container (
      margin: EdgeInsets.symmetric(vertical: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
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
                  widget.post.user!.profileImageUrl != null
                      ? widget.post.user!.profileImageUrl!
                      : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'
              ),
            ),
            title: Text(widget.post.user!.userName),
            subtitle: Text(formatter.format(widget.post.createdAt)),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => UserDetailsScreen(user: widget.post.user!))
              );
            },
            trailing: PopupMenuButton<String>(
              color: Colors.white,
              onSelected: (String value) {
                if (value == 'Delete') {
                  _dialogBuilder(context);
                }
              },
              itemBuilder: (ctx) {
                return <PopupMenuEntry<String>>[
                  if (widget.post.userId == user.id)
                    PopupMenuItem(value: 'Delete', child: ListTile(
                      title: Text('Delete', style: TextStyle(color: Colors.red),),
                      leading: Icon(Icons.delete, color: Colors.red,),)
                    ),
                  PopupMenuItem(value: 'Report', child: ListTile(title: Text('Report'), leading: Icon(Icons.flag),)),
                  PopupMenuItem(value: 'Approve', child: ListTile(title: Text('Approve'), leading: Icon(Icons.thumbs_up_down),))
                ];
              },
            ),
          ),
          if (widget.post.imageUrl !=  null)
            Image.network(widget.post.imageUrl!, fit: BoxFit.fill,
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
                  Text(widget.post.title, style: TextStyle(fontWeight: FontWeight.bold),),
                  if (widget.post.description != null)
                    Text(widget.post.description!)
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
                    onPressed: () async {
                      if (_isLiked) {
                        user.likedPostIds.remove(widget.post.id);
                      } else {
                        user.likedPostIds.add(widget.post.id);
                      }
                      await user.update();
                      setState(() {});
                    },
                    icon: _isLiked ? Icon(Icons.favorite, color: Colors.red,) : Icon(Icons.favorite_border)
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