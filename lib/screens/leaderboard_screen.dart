import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/widgets/leaderboard_sub_tab.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  LeaderboardScreen({super.key, required this.currentUser, required this.users});

  User currentUser;
  List<User> users;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: TabBar(
                indicatorColor: Theme.of(context).colorScheme.tertiary,
                labelColor: Theme.of(context).colorScheme.tertiary,
                unselectedLabelColor: Theme.of(context).colorScheme.tertiary.withAlpha(100),
                tabs: <Widget>[
                  Tab(
                    text: 'Global',
                    icon: Icon(Icons.language),
                  ),
                  Tab(
                    text: 'Friends',
                    icon: Icon(Icons.group),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  LeaderboardSubTab(users: users),
                  LeaderboardSubTab(users: users.where(
                          (user) => currentUser.friends.contains(user.id) || user.id == currentUser.id
                  ).toList()),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}