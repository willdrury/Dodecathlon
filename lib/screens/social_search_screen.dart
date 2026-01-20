import 'package:dodecathlon/models/post.dart';
import 'package:dodecathlon/providers/posts_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/providers/users_provider.dart';
import 'package:dodecathlon/screens/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';

class SocialSearchScreen extends ConsumerStatefulWidget {
  SocialSearchScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SocialSearchScreenState();
  }
}

class _SocialSearchScreenState extends ConsumerState<SocialSearchScreen> {

  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Post>> postStream = ref.watch(postsProvider);
    AsyncValue<List<User>> usersStream = ref.watch(usersProvider);
    User? currentUser = ref.watch(userProvider);

    if (!postStream.hasValue || !usersStream.hasValue || currentUser ==  null) {
      return (Center(child: CircularProgressIndicator(),));
    }

    List<User> filteredUsers = usersStream.value!.where((u) =>
      u.id != currentUser!.id &&
      u.userName.toLowerCase().contains(_searchController.text.toLowerCase())
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Find Users' // TODO: also add searching for posts
          ),
          onChanged: (value) {
            setState(() {

            });
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            if (filteredUsers.isEmpty)
              Text('No users found', style: TextStyle(color: Colors.grey),),
            ListView.builder(
              shrinkWrap: true,
              itemCount: filteredUsers.length,
              itemBuilder: (ctx, i) {
                return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          filteredUsers[i].profileImageUrl != null
                              ? filteredUsers[i].profileImageUrl!
                              : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'
                      ),
                    ),
                    title: Text(filteredUsers[i].userName),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => UserDetailsScreen(user: filteredUsers[i]))
                      );
                    },
                );
              }
            )
          ],
        ),
      )
    );
  }
}