import 'package:dodecathlon/widgets/rankings_sub_tab.dart';
import 'package:flutter/material.dart';

class RankingsScreen extends StatelessWidget {
  const RankingsScreen({super.key});

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
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
              child: TabBar(
                indicatorColor: Theme.of(context).colorScheme.onTertiaryContainer,
                labelColor: Theme.of(context).colorScheme.onTertiaryContainer,
                unselectedLabelColor: Theme.of(context).colorScheme.onTertiaryContainer.withAlpha(100),
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
                  RankingsSubTab(isFriendsList: false,),
                  RankingsSubTab(isFriendsList: true,),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}