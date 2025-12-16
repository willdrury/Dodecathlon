import 'package:dodecathlon/models/user.dart';
import 'package:dodecathlon/providers/user_competition_rankings_provider.dart';
import 'package:dodecathlon/providers/user_event_rankings_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/providers/users_provider.dart';
import 'package:dodecathlon/widgets/leaderboard_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaderboardSubTab extends ConsumerStatefulWidget {
  const LeaderboardSubTab({super.key, required this.isFriendsList});

  final bool isFriendsList;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _LeaderboardSubTabState();
  }
}

class _LeaderboardSubTabState extends ConsumerState<LeaderboardSubTab> with SingleTickerProviderStateMixin {
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
    User? currentUser = ref.watch(userProvider);
    AsyncValue<List<User>> usersStream = ref.watch(usersProvider);
    AsyncValue<List<(String, int)>> userIdsByEventStream = ref.watch(userEventRankingsProvider);
    AsyncValue<List<(String, int)>> userIdsByCompetitionStream = ref.watch(userCompetitionRankingsProvider);

    if (currentUser == null
        || !usersStream.hasValue
        || !userIdsByEventStream.hasValue
        || !userIdsByCompetitionStream.hasValue
    ) {
      return Center(child: CircularProgressIndicator(),); // TODO: Better loadings screen
    }

    List<(String, int)> userIdsByEvent = userIdsByEventStream.value!;
    List<(String, int)> userIdsByCompetition = userIdsByCompetitionStream.value!;

    // TODO: Make more efficient
    if (widget.isFriendsList) {
      userIdsByEvent = userIdsByEvent.where((e) =>
        currentUser.friends.contains(e.$1) || e.$1 == currentUser.id
      ).toList();
      userIdsByCompetition = userIdsByCompetition.where((e) =>
          currentUser.friends.contains(e.$1) || e.$1 == currentUser.id
      ).toList();
    }

    List<User> usersByEvent = userIdsByEvent.map((e) =>
      usersStream.value!.firstWhere((e2) => e2.id == e.$1)
    ).toList();

    List<User> usersByCompetition = userIdsByCompetition.map((e) =>
        usersStream.value!.firstWhere((e2) => e2.id == e.$1)
    ).toList();

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
                  TextButton.icon(
                    onPressed: () {},
                    label: Text('Sort by'),
                    icon: Icon(Icons.filter_list),
                  ),
                  for(int i = 0; i < usersByCompetition.length; i++)
                    LeaderboardListItem(user: usersByCompetition[i], points: userIdsByCompetition[i].$2,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    label: Text('Sort by'),
                    icon: Icon(Icons.filter_list),
                  ),
                  for(int i = 0; i < usersByEvent.length; i++)
                    LeaderboardListItem(user: usersByEvent[i], points: userIdsByEvent[i].$2)
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}