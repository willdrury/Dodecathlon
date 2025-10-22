import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodecathlon/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class PostsProvider extends StateNotifier<List<Post>> {
  PostsProvider() : super([]);

  Future<void> loadPosts() async {
    print('loading posts');

    var snapshots = await FirebaseFirestore.instance.collection('posts').get();
    state = snapshots.docs.map((snapshot) {
      print(snapshot.data());
      return Post.fromMap(snapshot.data());
    }).toList();
  }
}

final postsProvider = StateNotifierProvider<PostsProvider, List<Post>>((ref) {
  final provider = PostsProvider();
  provider.loadPosts();
  FirebaseFirestore.instance.collection('posts').snapshots().listen((event) {
    provider.loadPosts();
  });
  return provider;
});