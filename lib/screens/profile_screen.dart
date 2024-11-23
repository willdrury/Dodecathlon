import 'package:dodecathlon/models/user.dart' as dd;
import 'package:dodecathlon/widgets/profile_picture_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_provider.dart';
import '../providers/users_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    dd.User currentUser = ref.watch(userProvider)!;
    List<dd.User> users = ref.watch(usersProvider);

    List<dd.User> usersByCompetition = List.from(users);
    usersByCompetition.sort((a,b) => b.currentCompetitionPoints[0] - a.currentCompetitionPoints[0]);
    dd.User listUser = usersByCompetition.where((u) => u.userName == currentUser.userName).toList()[0];
    int currentUserIndex = usersByCompetition.indexOf(listUser) + 1;

    int numFollowers = 0;
    for (dd.User u in users) {
      if (u.friends.contains(currentUser.id) && currentUser.id != u.id) {
        numFollowers++;
      }
    }

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
                        ProfilePictureInput(user: currentUser),
                        SizedBox(width: 40,),
                        Expanded(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(currentUser.userName, style: TextStyle(fontSize: 30),),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Current Points'),
                                    Text(currentUser.currentCompetitionPoints[0].toString())
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
                            Text(currentUser.friends.length.toString())
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text('Statistics'),
                    subtitle: Text('Joined Nov 1, 2024'),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.light_mode_outlined),
                    title: Text('Theme'),
                    subtitle: Text('System Default'),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications_outlined),
                    title: Text('Notification Settings'),
                    subtitle: Text('All Allowed'),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.person_outline),
                    title: Text('Manage Account'),
                    subtitle: Text('Email'),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              color: Colors.white,
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pop();
                  },
                  child: Text('Log Out', style: TextStyle(color: Colors.red),)
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      )
    );
  }
}