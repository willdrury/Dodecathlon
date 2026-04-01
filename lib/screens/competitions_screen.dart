import 'package:dodecathlon/providers/competition_provider.dart';
import 'package:dodecathlon/providers/settings_provider.dart';
import 'package:dodecathlon/providers/user_provider.dart';
import 'package:dodecathlon/screens/competition_creation_screen.dart';
import 'package:dodecathlon/widgets/competition_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/competition.dart';
import '../models/user.dart';

class CompetitionsScreen extends ConsumerWidget {
  const CompetitionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Competition>> competitionsStream = ref.watch(competitionProvider);
    var settings = ref.watch(settingsProvider);

    AsyncValue<User?> userStream = ref.watch(userProvider);
    if (!userStream.hasValue) {
      return const Center(child: CircularProgressIndicator(),);
    }

    User user = userStream.value!;

    if (!competitionsStream.hasValue) {
      return Center(child: CircularProgressIndicator(),);
    }

    String? currentCompetitionId = settings['current_competition'];
    Competition? currentCompetition;
    List<Competition> nonActiveUserCompetitions = [];
    List<Competition> nonUserCompetitions = [];
    for (Competition c in competitionsStream.value!) {
      if (user.competitions.contains(c.id) && c.id != currentCompetitionId) {
        nonActiveUserCompetitions.add(c);
      } else if (user.competitions.contains(c.id) && c.id == currentCompetitionId) {
        currentCompetition = c;
      } else {
        nonUserCompetitions.add(c);
      }
    }

    void onToggle(String id) async {
      if (user.competitions.contains(id)) {
        user.competitions.remove(id);
        if (currentCompetitionId == id) {
          settings = {...settings, 'current_competition': ''};
          await ref.read(settingsProvider.notifier).updateSettings(settings);
        }
      } else {
        user.competitions.add(id);
        if (currentCompetitionId == null || currentCompetitionId == '') {
          settings = {...settings, 'current_competition': id};
          await ref.read(settingsProvider.notifier).updateSettings(settings);
        }
      }
      await user.update();
    }
    
    return Scaffold(
        appBar: AppBar(
          title: Text('Competitions'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (currentCompetition != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Competition',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      CompetitionTile(
                        competition: currentCompetition,
                        onToggle: onToggle,
                        isUserComp: true,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                Text(
                  'Non-Active Competitions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (nonActiveUserCompetitions.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: nonActiveUserCompetitions.length,
                    itemBuilder: (ctx, i) {
                      return CompetitionTile(
                        competition: nonActiveUserCompetitions[i],
                        onToggle: onToggle,
                        isUserComp: true,
                      );
                    }),
                if (nonActiveUserCompetitions.isEmpty && currentCompetition == null)
                  Text(
                    'Select a competition from below, or create your own to get started',
                    style: TextStyle(
                      color: Colors.grey
                    )
                  ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Text(
                      'User Competitions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (ctx) => CompetitionCreationScreen())
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.blue,
                        )
                    )
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: nonUserCompetitions.length,
                  itemBuilder: (ctx, i) {
                    return CompetitionTile(
                      competition: nonUserCompetitions[i],
                      onToggle: onToggle,
                      isUserComp: false,
                    );
                  }),
              ],
            ),
          ),
        )
    );
  }
}