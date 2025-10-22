import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/users_provider.dart';

String kDefaultIcon = 'https://img.freepik.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3407.jpg?w=360';

class UserDetailsScreen extends ConsumerStatefulWidget {
  const UserDetailsScreen({super.key, required this.user});

  final User user;

  @override
  ConsumerState<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends ConsumerState<UserDetailsScreen> {

  void _toggleFriend(User currentUser) async {
    if(currentUser.friends.contains(widget.user.id)) {
      currentUser.friends.remove(widget.user.id);
    } else {
      currentUser.friends.add(widget.user.id!);
    }
    UserProvider().setUser(currentUser);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    User currentUser = ref.watch(userProvider)!;
    AsyncValue<List<User>> users = ref.watch(usersProvider);

    List<User> usersByCompetition = [];
    if (users.hasValue) {
      usersByCompetition = List.from(users.value!);
    }
    usersByCompetition.sort((a,b) => b.currentCompetitionPoints[0] - a.currentCompetitionPoints[0]);
    User listUser = usersByCompetition.where((u) => u.userName == widget.user.userName).toList()[0];
    int currentUserIndex = usersByCompetition.indexOf(listUser) + 1;

    int numFollowers = 0;
    if (users.hasValue) {
      for (User u in users.value!) {
        if (u.friends.contains(widget.user.id)) {
          numFollowers++;
        }
      }
    }


    Widget addFriendText = currentUser.friends.contains(widget.user.id)
      ? Text('Remove Friend', style: TextStyle(color: Colors.red))
      : Text('Add Friend', style: TextStyle(color: Colors.blue));

    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Container(
          color: Colors.black.withAlpha(7),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Container(// Profile Info
                height: 200,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: Row( // Profile pic
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              widget.user.profileImageUrl != null
                                  ? widget.user.profileImageUrl !
                                  : kDefaultIcon
                            ),
                          ),
                          SizedBox(width: 40,),
                          Expanded(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.user.userName, style: TextStyle(fontSize: 30),),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Current Points'),
                                      Text(widget.user.currentCompetitionPoints[0].toString())
                                    ],
                                  ),
                                  SizedBox(width: 20,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Current Rank'),
                                      Text(currentUserIndex.toString())
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: 40,
                      child: Row( // Followers
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Followers '),
                              Text(numFollowers.toString())
                            ],
                          ),
                          SizedBox(width: 50),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Following '),
                              Text(widget.user.friends.length.toString())
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              if (widget.user.id != currentUser.id)
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      _toggleFriend(currentUser);
                    },
                    style: ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(Colors.black12),
                    ),
                    child: addFriendText,
                  ),
                ),
              SizedBox(height: 10,),
            ],
          ),
        )
    );
  }
}