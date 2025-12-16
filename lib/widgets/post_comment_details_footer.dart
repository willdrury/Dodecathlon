import 'package:dodecathlon/models/post.dart';
import 'package:dodecathlon/models/post_comment.dart';
import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCommentDetailsFooter extends ConsumerStatefulWidget {
  const PostCommentDetailsFooter({super.key, required this.post});

  final Post post;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PostCommentDetailsFooterState();
  }
}

class _PostCommentDetailsFooterState extends ConsumerState<PostCommentDetailsFooter> {

  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  void _uploadPostComment(String userId) {
    PostComment comment = PostComment(
        body: _commentController.text,
        createdAt: DateTime.now(),
        userId: userId,
        postId: widget.post.id,
    );

    try {
      comment.upload();
    } catch (e) {
      print(e.toString()); // TODO: Better error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = ref.watch(userProvider);

    if (currentUser == null) {
      return Center(child: CircularProgressIndicator(),);
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: TextField(
              controller: _commentController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Add comment',
                hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
                border: InputBorder.none,
                suffixIcon: GestureDetector(
                  onTap: () {
                    _uploadPostComment(currentUser.id!);
                  },
                  child: Icon(Icons.send)
                )
              ),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        )
      ),
    );
  }
}