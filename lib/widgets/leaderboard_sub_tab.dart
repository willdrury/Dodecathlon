import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/widgets/leaderboard_list_item.dart';
import 'package:flutter/material.dart';

class LeaderboardSubTab extends StatefulWidget {
  LeaderboardSubTab({super.key, required this.users});

  List<User> users;

  @override
  State<StatefulWidget> createState() {
    return _LeaderboardSubTabState();
  }
}

class _LeaderboardSubTabState extends State<LeaderboardSubTab> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    List<User> usersByEvent = List.from(widget.users);
    usersByEvent.sort((a,b) => b.currentEventPoints[0] - a.currentEventPoints[0]);

    List<User> usersByCompetition = List.from(widget.users);
    usersByCompetition.sort((a,b) => b.currentCompetitionPoints[0] - a.currentCompetitionPoints[0]);

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
          ),
          child: TabBar.secondary(
            indicatorColor: Theme.of(context).colorScheme.tertiary,
            labelColor: Theme.of(context).colorScheme.tertiary,
            unselectedLabelColor: Theme.of(context).colorScheme.tertiary.withAlpha(100),
            controller: _tabController,
            tabs: const <Widget>[
              Tab(text: 'Overall'),
              Tab(text: 'Event'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(onPressed: () {}, label: Text('Sort by'), icon: Icon(Icons.filter_list),),
                  for(int i = 0; i < usersByCompetition.length; i++)
                    LeaderboardListItem(user: usersByCompetition[i], points: usersByCompetition[i].currentCompetitionPoints[0],)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(onPressed: () {}, label: Text('Sort by'), icon: Icon(Icons.filter_list),),
                  for(int i = 0; i < usersByEvent.length; i++)
                    LeaderboardListItem(user: usersByEvent[i], points: usersByEvent[i].currentEventPoints[0])
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}