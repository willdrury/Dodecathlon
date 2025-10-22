import 'package:dodecathlon/screens/account_management_screen.dart';
import 'package:dodecathlon/screens/notification_management_screen.dart';
import 'package:dodecathlon/screens/theme_selection_screen.dart';
import 'package:dodecathlon/screens/user_stats_screen.dart';
import 'package:dodecathlon/widgets/profile_picture_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/user.dart' as dd;
import '../providers/settings_provider.dart';
import '../providers/user_provider.dart';
import '../providers/users_provider.dart';

final formatter = DateFormat('yMMMMd');

class ProfileDetails extends ConsumerStatefulWidget {
  ProfileDetails({super.key});

  @override
  ConsumerState<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends ConsumerState<ProfileDetails> {

  @override
  Widget build(BuildContext context) {

    dd.User currentUser = ref.watch(userProvider)!;
    AsyncValue<List<dd.User>> users = ref.watch(usersProvider);
    Map<dynamic, dynamic> settings = ref.watch(settingsProvider);

    List<dd.User> usersByCompetition = [];
    if (users.hasValue) {
      usersByCompetition = List.from(users.value!);
    }
    usersByCompetition.sort((a,b) => b.currentCompetitionPoints[0] - a.currentCompetitionPoints[0]);
    dd.User listUser = usersByCompetition.where((u) => u.id == currentUser.id).toList()[0];
    int currentUserIndex = usersByCompetition.indexOf(listUser) + 1;

    int numFollowers = 0;
    if (users.hasValue) {
      for (dd.User u in users.value!) {
        if (u.friends.contains(currentUser.id) && currentUser.id != u.id) {
          numFollowers++;
        }
      }
    }

    String themeMode = settings['theme'] as String;
    themeMode = themeMode[0].toUpperCase() + themeMode.substring(1);

    return Column(
      children: [
        SizedBox(height: 10,),
        Container(// Profile Info
          height: 200,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          color: Theme.of(context).colorScheme.surface,
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
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Statistics'),
                subtitle: Text('Joined: ${formatter.format(currentUser.createdDate)}'),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => UserStatsScreen())
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.light_mode_outlined),
                title: Text('Theme'),
                subtitle: Text(themeMode),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => ThemeSelectionScreen())
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications_outlined),
                title: Text('Notification Settings'),
                subtitle: Text('Push, In-app, Email'),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => NotificationManagementScreen())
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Manage Account'),
                subtitle: Text('Email'),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => AccountManagementScreen())
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Container(
          color: Theme.of(context).colorScheme.surface,
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
    );
  }
}